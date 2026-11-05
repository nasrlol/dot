// Neovide-style cursor: on every move, the four corners of the cursor slide
// from the old cell to the new one independently. Corners facing the
// direction of travel arrive first and trailing ones lag behind, stretching
// the cursor into a smear that snaps back into the cell.
//
// Uses Ghostty's cursor uniforms (1.2+): iCurrentCursor/iPreviousCursor are
// (x, y, w, h) in pixels, (x, y) being the top-left corner with y up.

const float DURATION = 0.16;       // seconds, for jumps (neovide default)
const float SHORT_DURATION = 0.10; // seconds, for moves of a cell or two (6 frames at 60 Hz)
const float TRAIL = 0.65;          // smooth leading-corner stretch without harsh snap
const float HEIGHT = 0.5;          // fraction of the cell height the block cursor covers
const float GROW = 2.0;            // pixels added on top of HEIGHT
const float RADIUS = 2.0;          // corner radius in pixels

// The cursor rect (x, y, w, h) cut down to a band of HEIGHT, centred vertically.
// adjust-cursor-height doesn't affect the block cursor, so it's cropped here.
vec4 shrink(vec4 c) {
	float h = min(c.w * HEIGHT + GROW, c.w);
	return vec4(c.x, c.y - (c.w - h) * 0.5, c.z, h);
}

// Signed distance to a rect (x, y, w, h) with corners rounded by RADIUS.
float sdRoundRect(vec2 p, vec4 r) {
	vec2 half_size = r.zw * 0.5;
	vec2 q = abs(p - vec2(r.x + half_size.x, r.y - half_size.y)) - half_size + RADIUS;
	return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - RADIUS;
}

// Signed distance to a quad (negative inside), after Inigo Quilez's sdPolygon.
float sdQuad(vec2 p, vec2 v[4]) {
	float d = dot(p - v[0], p - v[0]);
	float s = 1.0;
	for (int i = 0, j = 3; i < 4; j = i, i++) {
		vec2 e = v[j] - v[i];
		vec2 w = p - v[i];
		vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
		d = min(d, dot(b, b));
		bvec3 c = bvec3(p.y >= v[i].y, p.y < v[j].y, e.x * w.y > e.y * w.x);
		if (all(c) || all(not(c)))
			s = -s;
	}
	return s * sqrt(d);
}

float easeOut(float x) {
	return 1.0 - pow(1.0 - x, 3.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	fragColor = texture(iChannel0, fragCoord / iResolution.xy);

	vec4 cur = iCurrentCursor;
	vec4 prev = iPreviousCursor;

	// Turn the parts of the cursor cell outside the rounded band back into an
	// ordinary cell: cursor colour becomes the background (sampled from the top row of
	// the cell to the left, which is leading, so it follows highlighted lines)
	// and the cursor-text glyph becomes foreground, keeping its antialiasing.
	// The cursor colour comes from what Ghostty already drew (a corner pixel,
	// clear of the glyph) rather than iCurrentCursorColor, which doesn't
	// always match it while typing.
	vec2 swatch = cur.xy + vec2(1.0, -1.0);
	vec3 color = texture(iChannel0, swatch / iResolution.xy).rgb;
	vec4 band = shrink(cur);
	vec2 p = fragCoord - cur.xy;
	if (iCursorVisible != 0 && iCurrentCursorStyle == CURSORSTYLE_BLOCK &&
	    p.x >= 0.0 && p.x < cur.z && p.y <= 0.0 && p.y > -cur.w) {
		vec3 bg = texture(iChannel0, (cur.xy + vec2(-1.0, -1.0)) / iResolution.xy).rgb;
		float ink = clamp(distance(fragColor.rgb, color) / max(distance(iCursorText, color), 0.001), 0.0, 1.0);
		float outside = smoothstep(-0.5, 0.5, sdRoundRect(fragCoord, band));
		fragColor.rgb = mix(fragColor.rgb, mix(bg, iForegroundColor, ink), outside);
	}

	cur = band;
	prev = shrink(prev);
	vec2 move = cur.xy - prev.xy;
	float elapsed = iTime - iTimeCursorChange;
	if (cur.z <= 0.0 || length(move) < 0.5 || elapsed >= DURATION)
		return;

	// Typing and single-cell motions get a quick, rigid slide like neovide's
	// short_animation_length; longer moves get the full stretched trail.
	bool short_move = abs(move.y) < 0.5 && abs(move.x) <= 2.0 * cur.z;
	float duration = short_move ? SHORT_DURATION : DURATION;
	float trail = short_move ? 0.0 : TRAIL;
	if (elapsed >= duration)
		return;

	// Corners as offsets from the top-left: TL, TR, BR, BL.
	vec2 corner[4] = vec2[4](vec2(0.0), vec2(1.0, 0.0), vec2(1.0, -1.0), vec2(0.0, -1.0));
	vec2 dir = normalize(move);
	vec2 quad[4];
	// Corners are inset by RADIUS and the distance offset by it below, which
	// rounds the quad's corners to match the resting cursor.
	for (int i = 0; i < 4; i++) {
		// How much this corner faces the direction of travel, 0..1.
		float lead = dot(normalize(corner[i] - vec2(0.5, -0.5)), dir) * 0.5 + 0.5;
		float t = clamp(elapsed / (duration * (1.0 - trail * lead)), 0.0, 1.0);
		vec2 inset = sign(vec2(0.5, -0.5) - corner[i]) * RADIUS;
		vec2 from = prev.xy + corner[i] * prev.zw + inset;
		vec2 to = cur.xy + corner[i] * cur.zw + inset;
		quad[i] = mix(from, to, easeOut(t));
	}

	float alpha = 1.0 - smoothstep(-0.5, 0.5, sdQuad(fragCoord, quad) - RADIUS);
	fragColor.rgb = mix(fragColor.rgb, color, alpha);
}

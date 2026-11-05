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
	for (int i = 0; i < 4; i++) {
		// How much this corner faces the direction of travel, 0..1.
		float lead = dot(normalize(corner[i] - vec2(0.5, -0.5)), dir) * 0.5 + 0.5;
		float t = clamp(elapsed / (duration * (1.0 - trail * lead)), 0.0, 1.0);
		vec2 from = prev.xy + corner[i] * prev.zw;
		vec2 to = cur.xy + corner[i] * cur.zw;
		quad[i] = mix(from, to, easeOut(t));
	}

	// Take the colour from the cursor Ghostty has already drawn at the
	// destination (a corner pixel, clear of the glyph) rather than
	// iCurrentCursorColor, which doesn't always match it while typing.
	vec2 swatch = cur.xy + vec2(1.0, -1.0);
	vec3 color = texture(iChannel0, swatch / iResolution.xy).rgb;

	float alpha = 1.0 - smoothstep(-0.5, 0.5, sdQuad(fragCoord, quad));
	fragColor.rgb = mix(fragColor.rgb, color, alpha);
}

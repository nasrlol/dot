// Neovide-style cursor: on every move, the four corners of the cursor slide
// from the old cell to the new one independently. Corners facing the
// direction of travel arrive first and trailing ones lag behind, stretching
// the cursor into a smear that snaps back into the cell.
//
// Uses Ghostty's cursor uniforms (1.2+): iCurrentCursor/iPreviousCursor are
// (x, y, w, h) in pixels, (x, y) being the top-left corner with y up.
//
// Ghostty's own cursor is hidden (cursor-opacity = 0 in config); this shader
// draws it instead, as a block inset into the cell with rounded corners, the
// glyph underneath punched out in the cell's background colour.

const float DURATION = 0.16;       // seconds, for jumps (neovide default)
const float SHORT_DURATION = 0.10; // seconds, for moves of a cell or two (6 frames at 60 Hz)
const float TRAIL = 0.65;          // smooth leading-corner stretch without harsh snap
const vec2 INSET = vec2(1.0, 3.0); // pixels trimmed off each side (x) and top/bottom (y)
const float RADIUS = 3.0;          // corner radius in pixels

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
	if (iCursorVisible == 0 || cur.z <= 0.0)
		return;

	vec2 move = cur.xy - prev.xy;
	float elapsed = iTime - iTimeCursorChange;

	// Typing and single-cell motions get a quick, rigid slide like neovide's
	// short_animation_length; longer moves get the full stretched trail.
	bool short_move = abs(move.y) < 0.5 && abs(move.x) <= 2.0 * cur.z;
	float duration = short_move ? SHORT_DURATION : DURATION;
	float trail = short_move ? 0.0 : TRAIL;
	bool animating = length(move) >= 0.5 && elapsed < duration;

	// Corners as offsets from the top-left: TL, TR, BR, BL.
	vec2 corner[4] = vec2[4](vec2(0.0), vec2(1.0, 0.0), vec2(1.0, -1.0), vec2(0.0, -1.0));
	vec2 dir = animating ? normalize(move) : vec2(0.0);
	vec2 quad[4];
	for (int i = 0; i < 4; i++) {
		// Pull each corner into the cell by the inset plus the radius; the
		// radius is added back below as a rounded edge.
		vec2 inward = vec2(1.0 - 2.0 * corner[i].x, -1.0 - 2.0 * corner[i].y);
		vec2 to = cur.xy + corner[i] * cur.zw + inward * (INSET + RADIUS);
		if (!animating) {
			quad[i] = to;
			continue;
		}
		// How much this corner faces the direction of travel, 0..1.
		float lead = dot(normalize(corner[i] - vec2(0.5, -0.5)), dir) * 0.5 + 0.5;
		float t = clamp(elapsed / (duration * (1.0 - trail * lead)), 0.0, 1.0);
		vec2 from = prev.xy + corner[i] * prev.zw + inward * (INSET + RADIUS);
		quad[i] = mix(from, to, easeOut(t));
	}

	float d = sdQuad(fragCoord, quad) - RADIUS;
	// The uniform is sRGB but this shader works in Ghostty's linear space
	// (alpha-blending = linear-corrected); decode it or it comes out washed out.
	vec3 c = iCurrentCursorColor.rgb;
	vec3 color = mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(0.04045, c));

	// Unfocused: a rounded outline, like Ghostty's hollow block.
	if (iFocus == 0) {
		float alpha = 1.0 - smoothstep(0.5, 1.5, abs(d + 0.5));
		fragColor.rgb = mix(fragColor.rgb, color, alpha);
		return;
	}

	// The cell's background, from a corner pixel outside the rounded block
	// (picks up cursorline and other highlighted cells), so the glyph can be
	// drawn in it on top of the cursor.
	vec2 swatch = cur.xy + vec2(0.5, -0.5);
	vec3 bg = texture(iChannel0, swatch / iResolution.xy).rgb;
	float glyph = smoothstep(0.05, 0.3, distance(fragColor.rgb, bg));
	float alpha = 1.0 - smoothstep(-0.5, 0.5, d);
	fragColor.rgb = mix(fragColor.rgb, mix(color, bg, glyph), alpha);
}

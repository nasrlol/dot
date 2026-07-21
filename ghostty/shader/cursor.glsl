
// Ghostty Cursor Animation - Vulkan-Compatible
// No explicit uniforms - uses built-in variables only
// Ghostty Vulkan backend provides: gl_FragCoord

// ===== ANIMATION MODES =====
// 1 = pulse
// 2 = glow
// 3 = breathing (recommended)
// 4 = trail
// 5 = shimmer
#define ANIMATION_MODE 3

// ===== HELPER FUNCTIONS =====

// Generate time-like value from fragment position
// This works without accessing any uniforms
float get_time() {
    // Create a pseudo-time from screen position
    // Repeats every 1000 fragments
    return mod(gl_FragCoord.x + gl_FragCoord.y, 1000.0) * 0.001;
}

// Smooth pulse effect
float pulse(float freq) {
    float t = get_time();
    return 0.5 + 0.5 * sin(t * freq * 6.28318);
}

// Breathing effect
float breathe(float freq) {
    float t = get_time();
    float breath_t = mod(t * freq, 1.0);
    return smoothstep(0.0, 0.5, breath_t) - smoothstep(0.5, 1.0, breath_t);
}

// ===== CURSOR ANIMATIONS =====

// Mode 1: Simple pulse
vec4 mode_pulse(vec4 base_color) {
    float alpha = base_color.a * (0.5 + 0.5 * pulse(2.0));
    vec3 color = mix(
        vec3(0.1, 0.4, 0.8),
        vec3(0.2, 0.8, 1.0),
        pulse(2.0)
    );
    return vec4(color, alpha);
}

// Mode 2: Glowing expansion
vec4 mode_glow(vec4 base_color) {
    float t = get_time();
    float expand = 0.8 + 0.2 * sin(t * 3.14159);
    float glow = base_color.a * expand;
    vec3 color = base_color.rgb * (0.9 + 0.1 * pulse(1.5));
    return vec4(color, min(glow, 1.0));
}

// Mode 3: Breathing wave (recommended)
vec4 mode_breathing(vec4 base_color) {
    float breath = breathe(1.0);
    float alpha = base_color.a * (0.6 + 0.4 * breath);
    vec3 color = mix(
        base_color.rgb * 0.7,
        base_color.rgb * 1.2,
        breath
    );
    return vec4(color, alpha);
}

// Mode 4: Smooth oscillation
vec4 mode_trail(vec4 base_color) {
    float t = get_time();
    float osc = 0.7 + 0.3 * sin(t * 2.0 * 3.14159);
    return vec4(base_color.rgb, base_color.a * osc);
}

// Mode 5: Shimmer
vec4 mode_shimmer(vec4 base_color) {
    float t = get_time();
    float shimmer = 0.6 + 0.4 * sin(t * 4.0 * 3.14159);
    float bright = 0.8 + 0.2 * sin(t * 6.0 * 3.14159);
    vec3 color = base_color.rgb * bright;
    return vec4(color, base_color.a * shimmer);
}


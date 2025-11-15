shader_type canvas_item;

// Wave parameters
uniform float amplitude = 0.05;
uniform float frequency = 5.0;
uniform float speed = 2.0;
uniform bool wave_downwards = true;
uniform bool effect_active = true;
uniform float wave_offset = 0.0;

void fragment() {
    if (effect_active) {
        // Calculate direction factor
        float direction = wave_downwards ? UV.y : (1.0 - UV.y);

        // Calculate wave effect
        float wave = sin(direction * frequency + TIME * speed + wave_offset) * amplitude;

        // Apply the wave distortion while keeping UVs within tile bounds
        vec2 distorted_uv = UV;
        distorted_uv.x = clamp(UV.x + wave, 0.0, 1.0);

        // Sample the texture with distortion
        COLOR = texture(TEXTURE, distorted_uv);
    } else {
        // Default rendering when effect is inactive
        COLOR = texture(TEXTURE, UV);
    }
}
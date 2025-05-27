shader_type canvas_item;

// Wave effect controls
uniform float amplitude = 0.02;
uniform float frequency = 8.0;
uniform float speed = 3.0;
uniform vec2 wave_direction = vec2(1.0, 0.2);
uniform float time_offset = 0.0;

// Distortion controls
uniform float distortion_strength = 0.01;
uniform float distortion_speed = 1.5;

void fragment() {
    // Normalize direction
    vec2 dir = normalize(wave_direction);
    
    // Calculate wave pattern (time-based animation)
    float wave = sin(TIME * speed + UV.x * frequency) * amplitude;
    
    // Create distortion effect
    vec2 distortion = vec2(
        sin(TIME * distortion_speed + UV.y * 20.0) * distortion_strength,
        cos(TIME * distortion_speed + UV.x * 20.0) * distortion_strength
    );
    
    // Apply both wave and distortion to UV
    vec2 distorted_uv = UV + dir * wave + distortion;
    
    // Sample texture with modified UVs
    COLOR = texture(TEXTURE, distorted_uv);
    
    // Optional: Add color tint to enhance effect
    COLOR.rgb = mix(COLOR.rgb, vec3(0.7, 0.8, 1.0), abs(wave) * 2.0);
}
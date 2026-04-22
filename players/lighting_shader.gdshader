shader_type canvas_item;

void fragment() {
    float dist = length(UV - vec2(0.5));
    
    // Quantize steps (lower = more pixelated bands)
    float steps = 6.0;
    float light = floor((1.0 - dist) * steps) / steps;
    
    COLOR = vec4(vec3(light), light);
}
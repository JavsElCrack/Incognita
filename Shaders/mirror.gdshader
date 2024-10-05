shader_type canvas_item;

void fragment() {
    vec2 mirrored_uv = vec2(1.0 - UV.x, UV.y);  // Flip horizontally
    COLOR = texture(TEXTURE, mirrored_uv);
}

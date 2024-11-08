shader_type canvas_item;
render_mode unshaded; // Credit: LiathTheCrow for original shader code

uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 level2 : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 level3 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 level4 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float threshold1 : hint_range(0.0, 1.0) = 0.4;
uniform float threshold2 : hint_range(0.0, 1.0) = 0.52;
uniform float threshold3 : hint_range(0.0, 1.0) = 0.8;
uniform float effect_strength : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
    float rgb_avg = (original_color.r + original_color.g + original_color.b) / 3.0;
    vec4 effect_color;
    
    if (rgb_avg < threshold1) {
        effect_color = level1;
    } else if (rgb_avg < threshold2) {
        effect_color = level2;
    } else if (rgb_avg < threshold3) {
        effect_color = level3;
    } else {
        effect_color = level4;
    }
    
    // Blend between the original color and the effect color based on effect_strength
    COLOR = mix(original_color, effect_color, effect_strength);
}

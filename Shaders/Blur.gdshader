shader_type canvas_item;

//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float blur = 0.;

void fragment() {
    COLOR = textureLod(TEXTURE, UV, blur);
}
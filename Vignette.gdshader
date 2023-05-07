shader_type canvas_item;

uniform float intensity;
uniform float opacity : hint_range(0, 1);
uniform vec3 colour : source_color;

float vignette(vec2 uv) {
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.;
	return 1. - pow(vignette, opacity * intensity);
}

void fragment() { COLOR = vec4(colour, mix(0, opacity, vignette(UV))); }
shader_type canvas_item;

uniform vec4 colour : source_color;
uniform float radius = .48;
uniform float softness = .02;


float rescale(float a, float b, float x) {
	return (x - a) / (b - a);
}

void fragment() {
	COLOR.rgb = colour.rgb;
	COLOR.a = smoothstep(colour.a, 0, rescale(radius, radius + softness, distance(UV, vec2(.5))));
}

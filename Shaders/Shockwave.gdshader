shader_type canvas_item;

uniform float force;
uniform float size;
uniform float thickness;


void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	
	float mask = (1.0 - smoothstep(size-0.1, size, distance(UV, vec2(0.5)))) *
		(smoothstep(size-thickness-0.1, size-thickness, distance(UV, vec2(0.5))));
	vec2 disp = normalize(UV - vec2(0.5)) * force * mask;
	COLOR = vec4(texture(SCREEN_TEXTURE, SCREEN_UV - disp).rgb, 1.0);
	//COLOR.rgb = vec3(mask);
}


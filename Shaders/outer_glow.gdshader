shader_type canvas_item;
render_mode blend_mix;

const float PI = 3.14159265358979323846;

uniform vec2 offset = vec2(0.0, 0.0);
uniform float size : hint_range(1.0, 2.0) = 1.0;
uniform int pixel_percision : hint_range(1, 256) = 1;
uniform vec4 modulate : hint_color;
uniform bool draw_center = true;
uniform float rotation = 0.0;
uniform float radius : hint_range(0.0, 1.415) = 1.0;
uniform bool show_radius = false;


float atan2(float x, float y)
{
	if (x > 0.0)
	{
		return atan(y/x);
	}
	else if (y > 0.0)
	{
		return PI / 2.0 - atan(x/y);
	}
	else if (y < 0.0)
	{
		return -PI / 2.0 - atan(x/y);
	}
	else if (x < 0.0)
	{
		return atan(y/x) + PI;
	}
	else
	{
		return 0.0;
	}
}

vec2 rotate(vec2 pos, float by, vec2 pivot, float new_size)
{
	float r = distance(pivot, pos);
	float angle = atan2(pos.x-0.5, pos.y-0.5);
	angle += by;
	r *= new_size;
	return vec2(cos(angle), sin(angle)) * r + pivot;
}

vec2 rotateMid(vec2 pos)
{
	return rotate(pos, rotation, vec2(0.5), 1.0);
}

float relative_dist(float a, float b, float x)
{
	return (x - a) / (b - a);
}


vec4 shadow(sampler2D tex, vec2 uv, vec2 ps, vec2 pos, float size_multiplier)
{
	vec2 new_pos = rotateMid(uv - pos * ps);
	new_pos = rotate(new_pos, 0.0, vec2(0.5), 1.0 / mix(1.0, size, size_multiplier));
	return vec4(
		modulate.rgb,
		texture(tex, new_pos).a
		* modulate.a
		* float(pixel_percision)
	);
}


vec4 blend(vec4 a, vec4 b)
{
	return mix(a, vec4(b.rgb, 1.0), b.a);
}


void fragment() {
	vec4 col = vec4(0.0);
	if (texture(TEXTURE, rotateMid(UV)).a < 1.0 && distance(vec2(0.5), UV) < radius/2.0)
	{
		col.rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		if (show_radius) { col = vec4(vec3(1.0) - modulate.rgb, 1.0); }
		int size_in_pixels = int((size - 1.0) / 2.0 / length(TEXTURE_PIXEL_SIZE));
		for (int i = 0; i <= int(max(offset.x, offset.y)) + size_in_pixels; i+=pixel_percision)
		{
			float x = float(i) / (max(offset.x, offset.y) + float(size_in_pixels));
			vec4 layer = shadow(TEXTURE, UV, TEXTURE_PIXEL_SIZE, mix(vec2(0.0), offset, x), x);
			if (layer.a > 0.0)
			{ col = blend(col, vec4(layer.rgb, layer.a * pow(1.0 - x, 2))); }
		}
	}
	if (draw_center)
	{
		vec4 tex = texture(TEXTURE, rotateMid(UV));
		col = mix(col, tex, float(tex.a==1.0));
	}
	COLOR = col;
}
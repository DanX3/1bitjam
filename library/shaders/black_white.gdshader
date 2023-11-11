shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform float threshold: hint_range(0.0, 1.0, 0.01);
uniform vec3 color1: source_color;
uniform vec3 color2: source_color;

void fragment() {
	COLOR = texture(screen_tex, SCREEN_UV);
	float avg = (COLOR.r + COLOR.g + COLOR.b) * 0.33333333;
	avg = step(threshold, avg);
	COLOR.rgb = avg < 0.5 ? color1 : color2;
}

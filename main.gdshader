shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 3.0;

void fragment() {
	vec2 screen_res = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 grid = screen_res / pixel_size;
	vec2 pixelated_uv = (floor(SCREEN_UV * grid) + 0.5) / grid;
	COLOR = texture(screen_texture, pixelated_uv);
}
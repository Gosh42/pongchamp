shader_type canvas_item;

uniform vec4 og_bright:hint_color;
uniform vec4 og_mid:hint_color;
uniform vec4 og_dark:hint_color;

uniform vec4 new_bright:hint_color;
uniform vec4 new_mid:hint_color;
uniform vec4 new_dark:hint_color;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if (current_pixel == og_bright)
		COLOR = new_bright;
	else if (current_pixel == og_mid)
		COLOR = new_mid;
	else if (current_pixel == og_dark)
		COLOR = new_dark;
	else
		COLOR = current_pixel;
}
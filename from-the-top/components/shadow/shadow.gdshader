shader_type canvas_item;

uniform vec4 color: source_color = vec4(0, 0, 0, 1);

void fragment() {
	vec4 col = color;
	col.a = texture(TEXTURE, UV).a * color.a;
	//col.a = color.a;
	COLOR = col;
}

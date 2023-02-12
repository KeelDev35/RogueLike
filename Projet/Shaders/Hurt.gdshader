shader_type canvas_item;

uniform vec4 flash_color : hint_color = vec4(1.0, 1.0, 1.0, 0.8);
uniform float opacity : hint_range(0.0, 1.0) = 0.0;

void fragment(){
	vec4 current_color = texture(TEXTURE, UV);
	if (current_color.a == 0.0){
		discard;
	}
	COLOR = mix(current_color, flash_color, opacity);
}
shader_type canvas_item;

uniform float blackout = 0;

void fragment() {
	vec4 input = texture(TEXTURE, UV);
	vec3 output = input.rgb;
	screen_uv_to_sdf(UV);
	if (input.r > blackout && input.g > blackout && input.b > blackout) {
		output = vec3(0, 0, 0);
	}
	COLOR.rgb = output.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

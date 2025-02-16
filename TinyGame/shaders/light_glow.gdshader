shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.r > 0.5 && color.g > 0.5) {
		COLOR.rgb = color.rgb * 15.0;
	} else {
		COLOR.rgb += 0.015;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

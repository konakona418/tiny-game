shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 outColor;
	vec4 sampleColor = texture(TEXTURE, UV);
	if (sampleColor.a != 0.0) {
		outColor = vec3(1.0, 1.0, 1.0) * 3.0;
	} else {
		outColor = sampleColor.rgb;
	}
	COLOR.rgb = outColor.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float outlineWidth = 1.0;
uniform vec4 outlineColor: source_color = vec4(0, 0, 0, 1);

uniform vec2 velocity = vec2(0, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	
	vec2 uvUp = uv + vec2(0, TEXTURE_PIXEL_SIZE.y) * outlineWidth;
	vec2 uvDown = uv - vec2(0, TEXTURE_PIXEL_SIZE.y) * outlineWidth;
	vec2 uvRight = uv + vec2(TEXTURE_PIXEL_SIZE.x, 0) * outlineWidth;
	vec2 uvLeft = uv - vec2(TEXTURE_PIXEL_SIZE.x, 0) * outlineWidth;
	
	vec4 colorAllOutline = texture(TEXTURE, uvUp) + texture(TEXTURE, uvDown) +
		texture(TEXTURE, uvLeft) + texture(TEXTURE, uvRight);
		
	colorAllOutline.rgb = outlineColor.rgb;
	colorAllOutline.a = min(colorAllOutline.a, 1.0);
		
	vec4 colorOriginal = texture(TEXTURE, uv);
	
	vec4 outColor;
	
	/*vec4 colorTrailing;
	vec2 dist = normalize(velocity);
	for (float i = 0.0; i < 4.0; ++i) {
		colorTrailing = mix(colorTrailing, texture(TEXTURE, UV - i * dist), 0.5);
	}*/
	
	if (colorOriginal.a > 0.0) {
		outColor = mix(colorOriginal * 3.5, colorAllOutline, 1.0 - colorOriginal.a);
	} else {
		outColor = colorOriginal;
	}
	// mix(colorOriginal * 3.0 + 0.05, colorAllOutline, 1.0 - colorOriginal.a);
	
	COLOR = outColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

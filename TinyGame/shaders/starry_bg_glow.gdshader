shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform vec2 amplitude = vec2(0.1, 0.1);
uniform float noiseScale = 1.0;
uniform vec2 shakeSpeed = vec2(0, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec4 disturbance = texture(noiseTexture, fract(noiseScale * uv + TIME * shakeSpeed));
	vec2 disturbedUv = disturbance.xy * amplitude.xy + uv;
	vec4 color = texture(TEXTURE, disturbedUv);
	if (color.r > 0.5 && color.g > 0.5) {
		COLOR.rgb = color.rgb * 15.0;
	} else {
		COLOR.rgb += 0.005;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

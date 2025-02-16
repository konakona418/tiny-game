shader_type canvas_item;
uniform sampler2D screenTexture: hint_screen_texture;
uniform sampler2D noiseTexture;
uniform vec2 amplitude = vec2(0.1, 0.1);
uniform float noiseScale = 1.0;
uniform vec2 shakeSpeed = vec2(0, 0);

varying vec2 screenUv;

void vertex() {
	// Called for every vertex the material is visible on.
	screenUv = (SCREEN_MATRIX * CANVAS_MATRIX * MODEL_MATRIX * vec4(1, 1, 1, 1)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec4 disturbance = texture(noiseTexture, fract(noiseScale * uv + TIME * shakeSpeed));
	vec2 disturbedUv = uv.xy + disturbance.xy * amplitude.xy;
	vec4 sampled = texture(screenTexture, disturbedUv);
	COLOR.rgb =  max(sampled.rgb, texture(screenTexture, uv).rgb * 0.2);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

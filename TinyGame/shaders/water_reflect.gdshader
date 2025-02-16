shader_type canvas_item;
uniform sampler2D screenTexture: hint_screen_texture;

uniform float yOffset = 1.6;

uniform sampler2D noiseTexture;
uniform vec2 amplitude = vec2(0.1, 0.1);
uniform float noiseScale = 1.0;
uniform vec2 shakeSpeed = vec2(0, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec2 reflected = vec2(uv.x, yOffset - uv.y);
	
	vec4 disturbance = texture(noiseTexture, fract(noiseScale * uv + TIME * shakeSpeed));
	vec2 disturbedUv = reflected.xy + disturbance.xy * amplitude.xy;
	
	vec4 sample = texture(screenTexture, disturbedUv);
	COLOR = sample * 0.6;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

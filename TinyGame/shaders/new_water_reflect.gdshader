shader_type canvas_item;
uniform sampler2D screenTexture: hint_screen_texture;

uniform float yOffset = 0.65;

uniform sampler2D noiseTexture;
uniform vec2 amplitude = vec2(0., 0.1);
uniform float noiseScale = 1.0;
uniform vec2 shakeSpeed = vec2(0, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	vec4 disturbance = texture(noiseTexture, fract(noiseScale * uv + TIME * shakeSpeed));
	vec2 disturbedUv = disturbance.xy * amplitude.xy + uv;
	
	vec4 sample;
	if (uv.y > yOffset) {
		//sample = vec4(1.0, 0, 0, 1.0);
		sample = texture(TEXTURE,  vec2(uv.x, yOffset * 2.0 - uv.y));
	} else {
		sample = texture(TEXTURE, uv);
	}
	COLOR = sample;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type spatial;

varying float height;
varying vec3 normal;

uniform float shellHeight;
uniform float density;
uniform float maxHeight;
uniform float radius;
uniform sampler2D gradient;
uniform sampler2D noiseTexture;

void vertex() {
	height = shellHeight * maxHeight;
	normal = NORMAL;
}

void fragment() {
	float rand = texture(noiseTexture, vec2(float(UV.x * density), float(UV.y * density))).r;
	vec2 localSpace = fract(UV * density) * 2.0 - 1.0;
	
	ALBEDO = texture(gradient, vec2(rand)).rgb;
	
	ALPHA = (sqrt(pow(localSpace.x, 2) + pow(localSpace.y, 2)) < radius * (rand - shellHeight) ? 1.0 : 0.0);
}

void light() {
	DIFFUSE_LIGHT = (dot(NORMAL, LIGHT) * 0.5 + 0.5) * ATTENUATION * LIGHT_COLOR * 0.2;
}

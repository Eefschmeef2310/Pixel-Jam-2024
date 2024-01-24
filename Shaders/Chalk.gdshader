shader_type canvas_item;

uniform float width = 0.01;

uniform sampler2D noise;

const mat3 gx = mat3(
	 vec3(1.0,  2.0,  1.0),
	 vec3(0.0,  0.0,  0.0),
	 vec3(-1.0, -2.0, -1.0)
);

const mat3 gy = mat3(
	vec3(-1.0, 0.0, 1.0),
	vec3(-2.0, 0.0, 2.0 ),
	vec3(-1.0, 0.0, 1.0)
);

float intensity(vec3 pixel) {
	return (pixel.r + pixel.g + pixel.b) / 4.0;
}

float pixelIntensity(vec2 uv, vec2 d, sampler2D tex, vec2 iResolution) {
	vec3 pix = texture(tex, uv + d*2. / iResolution.xy).rgb;
	return intensity(pix);
}

float convolv(mat3 a, mat3 b) {
	float result = 0.0;

	for (int i=0; i<3; i++) {
		for (int j=0; j<3; j++) {
			result += a[i][j] * b[i][j];
		}
	}

	return result;
}

float sobel(vec2 uv, sampler2D tex, vec2 iResolution) {
	mat3 pixel = mat3(0.0);

	for (int x=-1; x<2; x++) {
		for (int y=-1; y<2; y++) {
			pixel[x+1][y+1] = pixelIntensity(uv, vec2(float(x), float(y)), tex, iResolution);
		}
	}

	float x = convolv(gx, pixel);
	float y = convolv(gy, pixel);

	return sqrt(x * x + y * y);
}

void fragment()
{
	vec2 uv = UV;
	
	float s = sobel(uv, TEXTURE, 1.0 / SCREEN_PIXEL_SIZE);
	
	float blackboard = texture(noise,uv).r;
	
	float color = max(s,0.)*(blackboard)+blackboard*.3;
	COLOR = vec4(color);
}
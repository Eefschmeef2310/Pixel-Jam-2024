shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	float average = (texture(TEXTURE, UV).r + texture(TEXTURE, UV).g + texture(TEXTURE, UV).b) / 3.;
	COLOR.rgb = vec3(average * texture(noise, UV).r * 3.0);
	//COLOR.a = texture(TEXTURE, UV).a * 1.;
}
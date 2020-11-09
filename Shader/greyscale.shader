shader_type spatial;

uniform sampler2D tex;

void fragment() {
	vec4 col = texture(tex, UV);
	vec3 colgrey = vec3(dot(col.rgb, vec3(0.3, 0.59, 0.11)));
	ALBEDO = colgrey.rgb;
	ALPHA = col.a;
}
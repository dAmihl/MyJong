shader_type spatial;

uniform vec2 amplitude = vec2(0.2, 0.1);
uniform vec2 frequency = vec2(3.0, 2.5);
uniform vec2 time_factor = vec2(2.0, 3.0);

uniform sampler2D texturemap : hint_albedo;
uniform vec2 texture_scale = vec2(8.0, 4.0);

uniform sampler2D uv_offset_texture : hint_albedo;
uniform vec2 uv_offset_scale = vec2(8.0, 4.0);
uniform float uv_offset_time_scale = 0.05;
uniform float uv_offset_amplitude = 0.2;

uniform sampler2D normal_map : hint_normal;

uniform float depth_distance = 1.0;
uniform float foam_amount = 1.0;
uniform float foam_cutoff = 1.0;
uniform vec4 foam_color : hint_color = vec4(1);

uniform sampler2D refraction_noise : hint_normal;
uniform sampler2D foam_noise : hint_black_albedo;
uniform sampler2D displacement_noise : hint_black;

uniform float refraction_speed = 0.25;
uniform float refraction_strength = 1.0;

float height(vec2 pos, float time){
	return (amplitude.x * sin(pos.x * frequency.x + time * time_factor.x)) * (amplitude.y * sin(pos.y * frequency.y + time * time_factor.y));
}

void vertex(){
	VERTEX.y += height(VERTEX.xz, TIME);
	
	TANGENT = normalize(vec3(0.0,height(VERTEX.xz + vec2(0.0, 0.2), TIME) - height(VERTEX.xz + vec2(0.0, -0.2), TIME), 0.4));
	BINORMAL = normalize(vec3(0.4,height(VERTEX.xz + vec2(0.2, 0.0), TIME) - height(VERTEX.xz + vec2(-0.2, 0.0), TIME), 0.0));
	NORMAL = cross(TANGENT, BINORMAL);
}

void fragment(){
	vec2 base_uv_offset = UV * uv_offset_scale;
	base_uv_offset += TIME * uv_offset_time_scale;
	
	vec2 texture_based_offset = texture(uv_offset_texture, base_uv_offset).rg;
	texture_based_offset = texture_based_offset * 2.0 - 1.0;
	
	vec2 texture_uv = UV * texture_scale;
	texture_uv += uv_offset_amplitude * texture_based_offset;
	
	NORMALMAP = texture(normal_map, base_uv_offset).rgb;
	
	float real_depth = texture(DEPTH_TEXTURE, SCREEN_UV).r * 2.0 - 1.0;
	real_depth = PROJECTION_MATRIX[3][2] / (real_depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	
	//Get the raw linear depth from the depth texture into a  [-1, 1] range
	float depth = texture(DEPTH_TEXTURE, texture_uv).r * 2.0 - 1.0;
	//Recreate linear depth of the intersecting geometry using projection matrix, and subtract the vertex of the sphere
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	
	depth = max(depth, real_depth);
	
	vec4 out_color = vec4(texture(texturemap, texture_uv).rgb, clamp((depth / depth_distance), 0, 1));
	
	if (out_color.r > 0.9 && out_color.g > 0.9 && out_color.b > 0.9){
		ALPHA = 0.9;
	} else {
		ALPHA = 0.5;
	}
	float intersection = clamp(depth / foam_amount, 0, 1) * foam_cutoff;
	vec3 foam = step(intersection, texture(foam_noise, UV + (TIME * amplitude) * refraction_speed).rgb) * foam_color.rgb;
	
	ALBEDO = out_color.rgb + foam;
}

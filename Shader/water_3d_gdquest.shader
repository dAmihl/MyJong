shader_type spatial;
//render_mode unshaded;

uniform vec4 deep_color : hint_color;
uniform vec4 shallow_color : hint_color = vec4(1);

uniform float refraction_speed = 0.25;
uniform float refraction_strength = 1.0;

uniform vec2 amplitude = vec2(0.2, 0.1);
uniform vec2 frequency = vec2(3.0, 2.5);
uniform vec2 time_factor = vec2(2.0, 3.0);

uniform float foam_amount = 1.0;
uniform float foam_cutoff = 1.0;
uniform vec4 foam_color : hint_color = vec4(1);

uniform float displacement_strength = 0.25;

uniform float depth_distance = 1.0;

uniform vec2 movement_direction = vec2(1,0);

uniform sampler2D refraction_noise : hint_normal;
uniform sampler2D foam_noise : hint_black_albedo;
uniform sampler2D displacement_noise : hint_black;

float height(vec2 pos, float time){
	float displacement = textureLod(displacement_noise, pos + (time * movement_direction) * refraction_speed, 0.0).r * 2.0 - 1.0;
	return displacement * displacement_strength;
}

float height2(vec2 pos, float time){
	return (amplitude.x * sin(pos.x * frequency.x + time * time_factor.x)) * (amplitude.y * sin(pos.y * frequency.y + time * time_factor.y));
}

void vertex() {
	float displacement = height2(VERTEX.xz, TIME);
	VERTEX.y += displacement;
	
	TANGENT = normalize(vec3(0.0,height2(VERTEX.xz + vec2(0.0, 0.2), TIME) - height2(VERTEX.xz + vec2(0.0, -0.2), TIME), 0.4));
	BINORMAL = normalize(vec3(0.4,height2(VERTEX.xz + vec2(0.2, 0.0), TIME) - height2(VERTEX.xz + vec2(-0.2, 0.0), TIME), 0.0));
	NORMAL = cross(TANGENT, BINORMAL);
}

void fragment() {
	vec2 uv = SCREEN_UV + (texture(refraction_noise, UV + (TIME * movement_direction) * refraction_speed).rg * 2.0 - 1.0) * refraction_strength;
	
	float real_depth = texture(DEPTH_TEXTURE, SCREEN_UV).r * 2.0 - 1.0;
	real_depth = PROJECTION_MATRIX[3][2] / (real_depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	
	//Get the raw linear depth from the depth texture into a  [-1, 1] range
	float depth = texture(DEPTH_TEXTURE, uv).r * 2.0 - 1.0;
	//Recreate linear depth of the intersecting geometry using projection matrix, and subtract the vertex of the sphere
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	
	depth = max(depth, real_depth);
	
	float intersection = clamp(depth / foam_amount, 0, 1) * foam_cutoff;
	
	vec4 out_color = mix(shallow_color, deep_color, clamp((depth / depth_distance), 0, 1));
	vec4 scene_color = texture(SCREEN_TEXTURE, uv);
	out_color = mix(scene_color, out_color, out_color.a);
	
	vec3 foam = step(intersection, texture(foam_noise, UV + (TIME * movement_direction) * refraction_speed).rgb) * foam_color.rgb;
	
	ALBEDO = out_color.rgb + foam;
}
//this is the type for 3d models
// there are canvasitem, partivle, fog, sky shaders too
shader_type spatial;

//render_modes:
// unshaded - no lightting
//
//render_mode diffuse_toon, specular_toon;
//unsure what toon does i thought it was outline
//but it does change things, less intense
render_mode specular_toon;

// this is a texture
//but godot lets us send some noise
uniform sampler2D noise;
uniform float height_scale = 0.5;
uniform sampler2D normalmap;
varying vec2 tex_position;
varying vec2 pos;
varying float hm;
uniform float scale =10.0;

//float heightmap(vec2 position, float time){
	//vec2 offset =0.01 * cos(position + time);
	//return texture(noise, (position/scale) -offset).x;
//}

float heightmap(vec2 position, float time){
	float h = waves(position);
	return h;
	}

float waves( vec2 position){
	position+= texture(noise, position/scale).x *2.0 -1.0;
	vec2 wave = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wave.x + wave.y, 0.65), 4.0);
}

	// Called for every vertex the material is visible on.
void vertex() {
	float period = 4.0;
	tex_position =VERTEX.xz/2.0 +0.5;
	// rgba is the same as xyzw so x = r in this case
	pos = VERTEX.xz;
	float height = texture(noise, tex_position).r;
	 hm = heightmap(pos, TIME);
	//VERTEX.y += height * height_scale;
	//VERTEX.y += cos(VERTEX.x* period ) * sin (VERTEX.z* period);
	VERTEX.y = hm;
}


void fragment() {
	// Called for every pixel the material is visible on.
	//NORMAL_MAP = texture(normalmap, tex_position).xyz;
	NORMAL = normalize(vec3(hm - heightmap(pos + vec2(0.1, 0.0), TIME), 
	0.1, 
	hm - heightmap(pos + vec2(0.0, 0.1), TIME)));	
	float fresnel = sqrt(1.0) - dot(NORMAL, VIEW);
	
	//rim lighting
	RIM =0.2;
	
	//lower the more smooth, higher more mat
	ROUGHNESS = 0.03 * (1.0 - fresnel);
	
	METALLIC =0.0;
	ALBEDO = vec3(0.05,0.2,0.8) +(0.1*fresnel);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

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

	// Called for every vertex the material is visible on.
void vertex() {
	float period = 4.0;
	tex_position =VERTEX.xz/2.0 +0.5;
	// rgba is the same as xyzw so x = r in this case
	float height = texture(noise, tex_position).r;
	VERTEX.y += height * height_scale;
	//VERTEX.y += cos(VERTEX.x* period ) * sin (VERTEX.z* period);
}

void fragment() {
	// Called for every pixel the material is visible on.
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
	
	float fresnel = sqrt(1.0) - dot(NORMAL, VIEW);
	
	//rim lighting
	RIM =0.2;
	
	//lower the more smooth, higher more mat
	ROUGHNESS = 0.03 * (1.0 - fresnel);
	
	METALLIC =0.0;
	ALBEDO = vec3(0.5,0.2,0.8) +(0.1*fresnel);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

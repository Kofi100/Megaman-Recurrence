shader_type canvas_item;
uniform bool isActive=false;
const vec4 colorEffect= vec4(1,1,1,1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color=texture(TEXTURE,UV);//get original colour
	if(isActive){
		if(color.a!=0.0){
			COLOR=colorEffect;
		}
	}
	else{
		COLOR=color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

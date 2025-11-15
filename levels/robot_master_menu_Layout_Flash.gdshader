shader_type canvas_item;
uniform vec4 blackColorSample:source_color;
uniform vec4 blueColorSample:source_color;
uniform bool startBlinking=false;
//varying float five=5.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color=texture(TEXTURE,UV);
	if(((color==blackColorSample)||(distance(color,blueColorSample)<=0.1)) && startBlinking==true){
		//old code
		float blink=(sin(TIME*25.0)+1.0)/2.0;
		COLOR=mix(color,vec4(1.0,1.0,1.0,1.0),blink);
		//COLOR=vec4(1,1,1,1);
		//|| color==blueColorSample

	}
	//if(distance(color,blueColorSample)<=0.1 && startBlinking==true){
		//float blink=(sin(TIME*25.0)+1.0)/2.0;
		//COLOR=mix(color,vec4(1.0,1.0,1.0,1.0),blink);
	//}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

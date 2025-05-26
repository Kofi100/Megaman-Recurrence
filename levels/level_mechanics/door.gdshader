shader_type canvas_item;
uniform vec4 greyOriginal:source_color;
uniform vec4 greyReplacement:source_color;
uniform vec4 whiteOriginal:source_color;
uniform vec4 whiteReplacement:source_color;
void fragment() {
//pass
	vec4 color=texture(TEXTURE,UV);
	if (color==greyOriginal){
		COLOR=greyReplacement;
	}
	else if (color==whiteOriginal){
		COLOR=whiteReplacement;
	}
}
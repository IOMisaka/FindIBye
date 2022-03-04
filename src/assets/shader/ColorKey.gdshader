shader_type canvas_item;
uniform vec4 color:hint_color;
void fragment(){
	vec4 rgba = texture(TEXTURE,UV).rgba;
	if(rgba.r==color.r && rgba.g==color.g && rgba.b==color.b){
		COLOR.a = 0.0;
	}else{
		COLOR=rgba;
	}
		
}
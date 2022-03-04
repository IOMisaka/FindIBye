shader_type canvas_item;
uniform vec4 color:hint_color;
uniform float range;
void fragment(){
	vec4 p = texture(TEXTURE,UV).rgba;
	vec4 delta = color-p;
	if(length(delta.rgb)<=range){
		COLOR.a = 0.0;
	}else{
		COLOR=p;
	}
		
}
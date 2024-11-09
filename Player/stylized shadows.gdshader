shader_type spatial;

uniform sampler2D noise_texture : source_color, filter_linear_mipmap, repeat_enable;

uniform float noise_strength_1;
uniform float noise_strength_2;

uniform vec4 albedo : source_color;

uniform float shadow_strenght;

uniform vec3 uv_scale_1;
uniform vec3 uv_offset_1;

uniform vec3 uv_scale_2;
uniform vec3 uv_offset_2;

uniform bool use_world;


//https://www.shadertoy.com/view/ws3Bzf
vec4 biplanar_sample( sampler2D tex, vec3 p, vec3 n, float k )
{
	
    // grab coord derivatives for texturing
    vec3 dpdx = dFdx(p);
    vec3 dpdy = dFdy(p);
    n = abs(n);

    // major axis (in x; yz are following axis)
    ivec3 ma = (n.x>n.y && n.x>n.z) ? ivec3(0, 1, 2) : 
              ((n.y>n.z)            ? ivec3(1, 2, 0) : 
                                      ivec3(2, 0, 1));
    // minor axis (in x; yz are following axis)
    ivec3 mi = (n.x<n.y && n.x<n.z) ? ivec3(0, 1, 2) :
              ((n.y<n.z)            ? ivec3(1, 2, 0) :
                                      ivec3(2, 0, 1));
        
    // median axis (in x;  yz are following axis)
    ivec3 me = ivec3(3) - mi - ma;
    
    // project+fetch
    vec4 x = textureGrad( tex, vec2(   p[ma.y],   p[ma.z]), 
                               vec2(dpdx[ma.y],dpdx[ma.z]), 
                               vec2(dpdy[ma.y],dpdy[ma.z]) );
    vec4 y = textureGrad( tex, vec2(   p[me.y],   p[me.z]), 
                               vec2(dpdx[me.y],dpdx[me.z]),
                               vec2(dpdy[me.y],dpdy[me.z]) );
    
    // blend and return
    vec2 m = vec2(n[ma.x], n[me.x]);
    // optional - add local support (prevents discontinuty)
    m = clamp( (m-0.5773)/(1.0-0.5773), 0.0, 1.0 );
    // transition control
    m = pow( m, vec2(k/8.0) );
	return (x*m.x + y*m.y) / (m.x + m.y);
}


varying vec3 _normal;
varying vec3 _vertex;
varying mat4 model_view_mat;

void vertex() {
	
	_vertex = VERTEX;
	_normal = NORMAL;
	
	if ( use_world ){
		_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz;
		_normal = mat3(MODEL_MATRIX) * NORMAL;
	}
	
	model_view_mat = MODELVIEW_MATRIX;
}

varying vec3 vertex_offset_1;
varying vec3 vertex_offset_2;

void fragment(){
	
	vec4 noise_offset_1 = biplanar_sample(noise_texture, _vertex * uv_scale_1 + uv_offset_1, _normal, 8.0) * noise_strength_1;
	vec4 noise_offset_2 = biplanar_sample(noise_texture, _vertex * uv_scale_2 + uv_offset_2, _normal, 8.0) * noise_strength_2;
	 
 
	vertex_offset_1 = _vertex + noise_offset_1.xyz;
	vertex_offset_2 = _vertex + noise_offset_2.xyz;
	

	if ( use_world ){
		vertex_offset_1 = (VIEW_MATRIX * vec4(vertex_offset_1, 1.0)).xyz;
		vertex_offset_2 = (VIEW_MATRIX * vec4(vertex_offset_2, 1.0)).xyz;
	}else{
		vertex_offset_1 = (model_view_mat * vec4(vertex_offset_1, 1.0)).xyz;
		vertex_offset_2 = (model_view_mat * vec4(vertex_offset_2, 1.0)).xyz;
	}

	ALBEDO = albedo.rgb;
	
}

void light() {
	

	if( LIGHT_IS_DIRECTIONAL){
		
		float shadow_1 = sample_directional_shadow(LIGHT_INDEX, vertex_offset_1);
		float shadow_2 = sample_directional_shadow(LIGHT_INDEX, vertex_offset_2);
	
		float shadow = mix(shadow_1, shadow_2, 0.5);
		shadow = mix(1.0, shadow, shadow_strenght);
		
		DIFFUSE_LIGHT = shadow * ALBEDO;

	}
}

//@renderpasses 0

varying vec2 v_TexCoord0;
varying vec4 v_Color;

//@vertex

attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;

uniform mat4 r_ModelViewProjectionMatrix;

uniform vec4 m_ImageColor;

void main(){

	v_TexCoord0=a_TexCoord0;
	
	v_Color=m_ImageColor * a_Color;
	
	gl_Position=r_ModelViewProjectionMatrix * a_Position;
}

//@fragment

uniform sampler2D m_ImageTexture0;
uniform vec2 m_curve;
uniform vec2 m_scale;
uniform vec2 m_translate;
uniform vec2 m_resolution;
uniform float m_scanline_intensity;
uniform float m_rgb_split_intensity;
uniform float m_brightness;
uniform float m_contrast;
uniform float m_gamma;

void main(){

#if MX2_RENDERPASS==0
	// get color for position on screen:
	vec2 resfac = m_resolution/vec2(800.0, 600.0);
	float bl = 0.03;
	float x = v_TexCoord0.x*(1.0+bl)-bl/2.0;
	float y = v_TexCoord0.y*(1.0+bl)-bl/2.0;
	float x2 = (x-0.5)*(1.0+  0.5*(0.3*m_curve.x)  *((y-0.5)*(y-0.5)))/m_scale.x+0.5-m_translate.x;
	float y2 = (y-0.5)*(1.0+  0.25*(0.3*m_curve.y)  *((x-0.5)*(x-0.5)))/m_scale.y+0.5-m_translate.y;
	vec2 v2 = vec2(x2, y2);
	vec4 temp = texture2D(m_ImageTexture0, v2*resfac);
	
	// brightness and contrast:
	temp = clamp(vec4((temp.rgb - 0.5) * (m_contrast*2.0) + 0.5 + (m_brightness*2.0-1.0), 1.0), 0.0, 1.0);
	
	// gamma:
	float gamma2 = 2.0-m_gamma*2.0;
	temp = vec4(pow(abs(temp.r), gamma2),pow(abs(temp.g), gamma2),pow(abs(temp.b), gamma2), 1.0);
	
	// grb splitting and scanlines:
	if (v2.x<0.0 || v2.x>1.0 || v2.y<0.0 || v2.y>1.0) {
		temp = vec4(0.0,0.0,0.0,1.0);
	}else{

		float cr = sin((x2*m_resolution.x)               *2.0*3.1415) * 0.5+0.5+0.1;
		float cg = sin((x2*m_resolution.x-1.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
		float cb = sin((x2*m_resolution.x-2.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
		temp = mix(temp*vec4(cr,cg,cb,1.0),temp,1.0-m_rgb_split_intensity);
		float ck = (sin((y2*m_resolution.y)*2.0*3.1415) +0.5+0.1)*m_scanline_intensity;
		temp = temp*0.9 + temp*ck*0.1;
	}
	
	// final color:
	gl_FragColor = vec4((temp.rgb * v_Color.rgb)*0.9+0.1, v_Color.a);
	
#else
	float alpha=texture2D( m_ImageTexture0,v_TexCoord0 ).a * v_Color.a;
	gl_FragColor=vec4( 0.0,0.0,0.0,alpha );
#endif
}


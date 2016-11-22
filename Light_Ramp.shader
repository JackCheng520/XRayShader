//Light_Ramp 渐变贴图Shader；
//added by LY;
//2016-5-25
Shader "LYShaderLib/Light_Ramp" {
	Properties {
		_MainTex ("Base (RGB)",2D)		    = "white" {}
		_RampTex ("Ramp (RGB)",2D)          = "white" {}
		_Color("Color",Color) = (0.5,0.5,0.5,0.5)
		_Type("Blend Type",Float) = 0
	}
	SubShader {
		Tags {  "QUEUE"="Geometry+501"  "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
	 
		#pragma surface surf BasicDiffuse

		sampler2D _MainTex;
		sampler2D _RampTex;
		half4 _Color;
		float _Type;
 
		struct Input {
			float2 uv_MainTex;
		};
	

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c  = tex2D(_MainTex,IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha  = c.a; 
		}

		inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){

			float difLight = dot(s.Normal,lightDir);
			float rimLight = dot(s.Normal,viewDir );
			float hLambert = difLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTex,float2(hLambert,rimLight)).rgb;

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			col.a   = s.Alpha;

			if(_Type > 0){
				col = col + _Color;
			}else{
				col = col * _Color;
			}
			
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}

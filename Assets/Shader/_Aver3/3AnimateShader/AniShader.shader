Shader "Custom/AniShader" {
	Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _SizeX ("列数", Float) = 4
    _SizeY ("行数", Float) = 4
    _Speed ("播放速度", Float) = 200
	}
	
	SubShader {
	    Tags { "RenderType"="Opaque"}
	    LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert alpha
		
		sampler2D _MainTex;
		fixed4 _Color;
		
		uniform fixed _SizeX;
		uniform fixed _SizeY;
		uniform fixed _Speed;
		
		struct Input {
		    float2 uv_MainTex;
		};
		
		void surf (Input IN, inout SurfaceOutput o) {
		    
		    int index = floor(_Time .x * _Speed);
		    int indexY = index/_SizeX;
		    int indexX = index - indexY * _SizeX;
		    float2 testUV = float2(IN.uv_MainTex.x /_SizeX, IN.uv_MainTex.y /_SizeY);
		    
		    testUV.x += indexX/_SizeX;
		    testUV.y += indexY/_SizeY;
		    
		    fixed4 c = tex2D(_MainTex, testUV) * _Color;
		    o.Albedo = c.rgb;
		    
		    o.Alpha = c.a;
		    //o.Albedo = float3( floor(_Time .x * _Speed) , 1.0, 1.0);
		}
	ENDCG
	}
	Fallback "Transparent/VertexLit"
}

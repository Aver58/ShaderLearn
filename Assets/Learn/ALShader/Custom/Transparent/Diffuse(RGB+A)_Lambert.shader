Shader "Custom/Transparent/Diffuse(RGB+A)_Lambert"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex",2D) = "white" {}
	}

    SubShader {
        Tags {"Queue"="Transparent+2" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 200

        Cull Off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade vertex:vert

		fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _AlphaTex;

        struct Input {
            float2 uv_MainTex;
            float4 color;
        };

        void vert(inout appdata_full v, out Input o)  
        {  
            UNITY_INITIALIZE_OUTPUT(Input,o);

            o.color = v.color;
        } 

        void surf (Input IN, inout SurfaceOutput o) {
            fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed a = tex2D(_AlphaTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = a * IN.color.a;
			
			o.Albedo *= _Color.rgb;
			o.Alpha *= _Color.a;
        }

        ENDCG
    }

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

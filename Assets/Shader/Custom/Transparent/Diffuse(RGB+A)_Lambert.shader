Shader "Custom/Transparent/Diffuse(RGB+A)_Lambert"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex",2D) = "white" {}
	}

	SubShader{
		Tags {
			"Queue"="Transparent+2" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent"
		}

		Pass{
			Tags{"LightMode" = "ForwardBase"}

			Cull Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Assets/Shader/AL.cginc"

			struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
				float4 color : COLOR;
            };

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			
			v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 col = tex2D(_MainTex, i.uv);
                fixed alpha = tex2D(_AlphaTex, i.uv).r;
				
                fixed4 lastColor = fixed4(col, alpha) * i.color;
                return GetBrightnessColor(lastColor);
            }
			ENDCG
		}
	}

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Unlit/ColorTex(RGB+A)"
{
	Properties
	{
		_Color("EffectLight",Color) = (0,0,0,0)
		_MainColor ("Main Color", COLOR) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex",2D) = "white" {}
	}

	SubShader{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		Pass{
			Cull Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 col : COLOR0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 col : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			fixed4 _MainColor;
			float4 _Color;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.col = v.col;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed alpha = tex2D(_AlphaTex, i.uv).r;
				

				col.a *= alpha;
				col.rgb *= _MainColor.rgb;
				col.a *= _MainColor.a;
				col.rgb *= i.col.rgb;
				col.a *= i.col.a;

				fixed4 _EffectVar =  col + _Color * col;

				return _EffectVar;
			}
			ENDCG
		}
	}

    Fallback "Unlit/Transparent"
}

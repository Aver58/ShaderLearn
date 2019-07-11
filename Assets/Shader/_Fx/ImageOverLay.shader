// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/ImageOverLay"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{"Queue" = "Transparent"}
		// No culling or depth
		Cull Off ZWrite Off ZTest off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _BlendTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colMain = tex2D(_MainTex, i.uv);
				fixed4 colBlend = tex2D(_BlendTex, i.uv);

				fixed4 colTemp = colMain;
				colTemp.r = lerp(colBlend.r, colMain.r, 1-colBlend.a);
				colTemp.g = lerp(colBlend.g, colMain.g, 1-colBlend.a);
				colTemp.b = lerp(colBlend.b, colMain.b, 1-colBlend.a);
				colTemp.a = 1;
				return colTemp;
			}
			ENDCG
		}
	}
}

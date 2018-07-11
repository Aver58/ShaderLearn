Shader "SoarD/Transparent/SDCastleShadow" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
	}

		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Pass{
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

		fixed4 _Color;
		sampler2D _MainTex;

		struct a2v {
			float2 uv : TEXCOORD0;
			float4 vertex : POSITION;
		};

		struct v2f {
			float4 pos : SV_POSITION; 
			float2 uv : TEXCOORD0;
		};

		v2f vert(a2v IN)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(IN.vertex);
			o.uv = IN.uv;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv);
			col.a = col.r;
			col = col* _Color;
			return col;
			}
				ENDCG
		}
	}
}

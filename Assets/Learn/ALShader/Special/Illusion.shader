// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable

Shader "Character/Illusion" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_BaseOpacity ("BaseOpacity", Range(0,0.5)) = 0.6
		_Alpha("Alpha", Range(0, 1)) = 1
	}
	CGINCLUDE
	#include "UnityCG.cginc"

	ENDCG

	SubShader {
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		
		Pass{
			ZWrite On
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			uniform float _BaseOpacity;
			uniform float4 _Color;
			uniform float _Alpha;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
				return o;
			}

			float4 frag(v2f v) : SV_Target
			{
				float f = pow(1 - saturate(dot(v.viewDir,UnityObjectToWorldNormal(v.normal))),2)*(1-_BaseOpacity)+_BaseOpacity;			
				float4 c = _Color;
				c.a = f*_Alpha;
				return c; 
			}
			ENDCG
		}

	} 
	Fallback Off
}

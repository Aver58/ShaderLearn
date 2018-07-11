// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Transparent/Diffuse(RGB+A)"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex",2D) = "white" {}
	}

	SubShader{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		Pass{
			Tags{"LightMode" = "ForwardBase"}

			Cull Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed alpha = tex2D(_AlphaTex, i.uv).r;

				col.a *= alpha;

				float3 worldNormal = UnityObjectToWorldNormal(i.normal);
				float3 lightDir = UnityWorldSpaceLightDir(i.worldPos);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * col.rgb;

				//normal light
//				fixed3 diffuse = _LightColor0.rgb * col.rgb * saturate(dot(worldNormal, lightDir));

				//half lambert light
				float ha = dot(worldNormal, lightDir) * 0.5f + 0.5f;
				fixed3 diffuse = _LightColor0.rgb * col.rgb * ha;

				return fixed4(ambient + diffuse, col.a);
			}
			ENDCG
		}
	}

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This is a premultiply-alpha adaptation of the built-in Unity shader "UI/Default" to allow Unity UI stencil masking.

Shader "Spine/SkeletonGraphic (Premultiply Alpha)"
{
	Properties
	{
		_MainTex ("Sprite Texture", 2D) = "white" {}
		_AlphaTex("Sprite Alpha Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_Range ("Range", Range(0.0, 1.0)) = 0.0
		_Mix ("Mix", Range(0.001, 5.0)) = 1.0
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				half2 texcoord1	: TEXCOORD1;
			};
			
			fixed4 _Color;
			half _Range;
			half _Mix;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				
			#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
			#endif

				OUT.color = IN.color * _Color;

				OUT.texcoord1 = IN.texcoord1;
				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = tex2D(_MainTex, IN.texcoord);
				color.rgb *= IN.color.rgb;
				color.a = tex2D(_AlphaTex, IN.texcoord).r * IN.color.a;
				half alpha = saturate(pow(1.0 - (-IN.texcoord1.y + _Range) / _Range, _Mix));
				color.a *= alpha;
				return color;
			}
		ENDCG
		}
	}
}
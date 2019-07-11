// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "AL/UI/UIMaskImg"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

		//_Sprite ("Sprite", 2D) = "white" {}
		//_SpriteOffset ("SpriteOffset", Vector) = (0, 0, 0, 0)
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
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
			Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				float2 maskPos : TEXCOORD2;
				//float2 maskUV : TEXCOORD3;
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;

			float4x4 _WorldToMaskMatrix;
			float _MaskType;		//0：方，1：圆
			float4 _MaskRect;		//方：xMin, yMin, xMax, yMax，圆：r

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0) * float2(-1,1) * OUT.vertex.w;
				#endif
				
				OUT.color = IN.color * _Color;

				float4 worldPos = mul(unity_ObjectToWorld, IN.vertex);
				OUT.maskPos = mul(_WorldToMaskMatrix, worldPos).xy;
				//OUT.maskUV = float2((OUT.maskPos.x - _MaskRect.x) / (_MaskRect.z - _MaskRect.x), (OUT.maskPos.y - _MaskRect.y) / (_MaskRect.w - _MaskRect.y));

				return OUT;
			}

			sampler2D _MainTex;

			//sampler2D _Sprite;
			//float4 _SpriteOffset;

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = IN.color;
				
				color.a *= lerp(1 - saturate(UnityGet2DClipping(IN.maskPos, _MaskRect)), step(_MaskRect.x, length(IN.maskPos)), _MaskType);
				// * tex2D(_Sprite, IN.maskUV * _SpriteOffset.xy + _SpriteOffset.zw).a);

				color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
}

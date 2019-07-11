Shader "Jee/Common/LOFT(UV2)" {
    Properties {
    	[Header(Model)]
    	[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 2
		[Header(One One)]
		[Header(SrcAlpha OneMinusSrcAlpha)]
		[Header(One One)]
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1
		[Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
   		_Color ("Color", Color) = (0.5,0.5,0.5,1)
        _TexValue ("TexValue", Float ) = 1
        _MainTex ("MainTex", 2D) = "white" {}
        [KeywordEnum(Off,On)]_MaskEffect("Mask Effect",Float) = 0
        _Mask01 ("Mask01", 2D) = "white" {}
        [KeywordEnum(Off,On)]_Mask02FX("Mask02FX",Float) = 0
        _StepValue("StepValue", Range(0,1.05)) = 1.05
        _Mask02 ("Mask02", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        [Header(UI_Stencil)]
		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
		_ColorMask("Color Mask", Float) = 15
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
      	Stencil{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }   
				Cull [_Cull]
				Blend [_SrcBlend] [_DstBlend]
				ZWrite [_ZWrite]
				ZTest [_ZTest]   
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 2.0
            #pragma multi_compile _MASKEFFECT_ON _MASKEFFECT_OFF
            #pragma multi_compile _MASK02FX_ON _MASK02FX_OFF
           
            uniform sampler2D _MainTex; 
            uniform fixed4 _MainTex_ST;
            uniform fixed4 _Color;
            uniform fixed _TexValue;
            uniform fixed _StepValue;

            uniform sampler2D _Mask01;
            uniform fixed4 _Mask01_ST;
            uniform sampler2D _Mask02;
            uniform fixed4 _Mask02_ST;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.uv0 = v.texcoord0;
                o.uv2 = v.texcoord2;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _MainTexture = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = _Color.rgb * _MainTexture.rgb * _TexValue;
                float4 _MaskTexture01 = tex2D(_Mask01, TRANSFORM_TEX(i.uv0, _MainTex));
                float4 _MaskTexture02 = tex2D(_Mask02, TRANSFORM_TEX(i.uv2, _Mask02));
            #if _MASK02FX_ON
                 _MaskTexture02 = step(_MaskTexture02.r, _StepValue);
            #endif

            #if _MASKEFFECT_ON
				fixed4 finalRGBA = fixed4(finalColor, _MaskTexture02.r * _MaskTexture01.r * _Color.a);
			#else
                fixed4 finalRGBA = fixed4(finalColor * _MaskTexture02.r * _MaskTexture01.r * _Color.a , 1);
            #endif
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

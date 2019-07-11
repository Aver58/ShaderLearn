Shader "Jee/Common/Normal" {
    Properties {
    	[Header(Model)]
    	[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 2
    	[KeywordEnum(Off,On)]_Billboarding("Billboarding",Float) = 0
    	_VerticalBillboarding ("Vertical Restraints", Range(0, 1)) = 1 
		[Header(One One)]
		[Header(SrcAlpha OneMinusSrcAlpha)]
		[Header(One One)]
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1

		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
   		_Color ("Color", Color) = (0.5,0.5,0.5,1)
        _TexValue ("TexValue", Float ) = 1
        _MainTex ("MainTex", 2D) = "white" {}
        [KeywordEnum(Off,On)]_MaskEffect("Mask Effect",Float) = 0
        _Mask ("Mask", 2D) = "white" {}
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
				ZWrite Off
				ZTest [_ZTest] 
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 2.0
            #pragma multi_compile _MASKEFFECT_ON _MASKEFFECT_OFF
            #pragma multi_compile _BILLBOARDING_ON _BILLBOARDING_OFF


            uniform sampler2D _MainTex; 
            uniform fixed4 _MainTex_ST;
            uniform fixed4 _Color;
            uniform sampler2D _Mask; 
            uniform fixed4 _Mask_ST;
            uniform fixed _TexValue;
            fixed _VerticalBillboarding;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
              #if _BILLBOARDING_ON
                float3 center = float3(0, 0, 0);
				float3 viewer = mul(unity_WorldToObject,float4(_WorldSpaceCameraPos, 1));
				float3 normalDir = viewer - center;
				normalDir.y =normalDir.y * _VerticalBillboarding;
				normalDir = normalize(normalDir);
				float3 upDir = abs(normalDir.y) > 0.999 ? float3(0, 0, 1) : float3(0, 1, 0);
				float3 rightDir = normalize(cross(upDir, normalDir));
				upDir = normalize(cross(normalDir, rightDir));
				float3 centerOffs = v.vertex.xyz - center;
				float3 localPos = center + rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
				o.pos = UnityObjectToClipPos(float4(localPos, 1));
			  #else
			    o.pos = UnityObjectToClipPos(v.vertex );
			  #endif
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
            float4 _MainTexture = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = _Color.rgb * _MainTexture.rgb * _TexValue;
                float4 _MaskTexture = tex2D(_Mask, TRANSFORM_TEX(i.uv0, _Mask));
            #if _MASKEFFECT_ON
				fixed4 finalRGBA = fixed4(finalColor * i.vertexColor.rgb, _MaskTexture.r * _Color.a * i.vertexColor.a);
			#else
                fixed4 finalRGBA = fixed4(finalColor * _MaskTexture.r * _Color.a * i.vertexColor.rgb * i.vertexColor.a, 1);
            #endif
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

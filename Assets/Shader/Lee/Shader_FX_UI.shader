Shader "Lee/FX_UI" {
    Properties {
        [Header(Model)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1
		[Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0

        _01N_V ("01N_V", Float ) = 0
        _01N_Sin ("01N_Sin", Float ) = 0
        _01N_V_Add ("01N_V_Add", Float ) = 0
        _01N_U_Time ("01N_U_Time", Float ) = 0
        _01N_V_Time ("01N_V_Time", Float ) = 0
        _Color ("Color", Color) = (1,1,1,1)
        _Tex_Value ("Tex_Value", Float ) = 1
        _EmiTex ("EmiTex", 2D) = "white" {}
        _02J_U ("02J_U", Float ) = 0
        _02J_V ("02J_V", Float ) = 0
        _Lerp_Switch ("Lerp_Switch", Float ) = 0
        _LerpTex ("LerpTex", 2D) = "white" {}
        _Lerp_Value ("Lerp_Value", Float ) = 1
        _Lerp0_U ("Lerp0_U", Float ) = 0
        _Lerp0_V ("Lerp0_V", Float ) = 0
        _Lerp1_U ("Lerp1_U", Float ) = 0
        _Lerp1_V ("Lerp1_V", Float ) = 0
        _03Dis_Value ("03Dis_Value", Float ) = 0
        _03DisTex ("03DisTex", 2D) = "white" {}
        _03Dis_U ("03Dis_U", Float ) = 0
        _03Dis_V ("03Dis_V", Float ) = 0
        _MainTex ("MainTex", 2D) = "white" {}
        [Enum(None,0,0To1,1,0To1Wrapped,2)] _Switch01_N ("Switch01_N", Float ) = 0
        
        [MaterialToggle] _IsUI("_IsUI", Float) = 0
        
		[HideInInspector]_StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask("Color Mask", Float) = 15
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
			Cull [_Cull]
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
            ColorMask [_ColorMask]

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 2.0

            uniform float _01N_V;
            uniform float _01N_V_Time;
            uniform float _01N_Sin;
            uniform float _01N_U_Time;
            uniform float _01N_V_Add;
            uniform float4 _Color;
            uniform float _Tex_Value;
            uniform sampler2D _EmiTex; uniform float4 _EmiTex_ST;
            uniform float _02J_U;
            uniform float _02J_V;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _03Dis_U;
            uniform float _03Dis_V;
            uniform sampler2D _03DisTex; uniform float4 _03DisTex_ST;
            uniform float _03Dis_Value;
            uniform float _Lerp_Switch;
            uniform sampler2D _LerpTex; uniform float4 _LerpTex_ST;
            uniform float _Lerp0_U;
            uniform float _Lerp0_V;
            uniform float _Lerp1_U;
            uniform float _Lerp1_V;
            uniform float _Lerp_Value;
            uniform fixed _Switch01_N;

            fixed _IsUI;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color : Color;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TexCOORD1;
                float4 color : Color;
                float4 time : TexCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = lerp(o.uv0, v.texcoord1, _IsUI);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.time = _Time;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                
                float2 node_6102 = float2(_01N_U_Time * i.time.g + i.uv1.r, i.uv1.g + sin(i.uv1.r * _01N_V + _01N_V_Add + _01N_V_Time * i.time.g) * _01N_Sin);
                float2 node_3182 = node_6102 + float2(_03Dis_U, _03Dis_V) * i.time.g;
                float4 _03DisTex_var = tex2D(_03DisTex, TRANSFORM_TEX(node_3182, _03DisTex));
                float node_4589 = _03DisTex_var.r * _03Dis_Value;
                if(_Switch01_N < 0.5)
                {
                    float2 node_9412 = node_6102 + float2(_Lerp0_U * i.time.r, i.time.r * _Lerp0_V);
                    float4 node_5111 = tex2D(_LerpTex, TRANSFORM_TEX(node_9412, _LerpTex));
                    float2 node_9099 = node_6102 + float2(_Lerp1_U * i.time.r, i.time.r * _Lerp1_V);
                    float4 _node_5111_copy = tex2D(_LerpTex, TRANSFORM_TEX(node_9099, _LerpTex));
                    
                    float2 node_7642 = node_6102 + node_4589;
                    float4 node_4743 = tex2D(_EmiTex, TRANSFORM_TEX(node_7642, _EmiTex));
                    
                    float3 emissive = _Color.rgb * _Tex_Value * lerp(node_5111.r, _node_5111_copy.g, _Lerp_Switch) * _Lerp_Value * node_4743.rgb;
                    float4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                    return float4(emissive * i.color.rgb, _Color.a * _MainTex_var.r * _Tex_Value * i.color.a);
                }
                else
                {
                    float2 node_3528 = i.uv1 * 2.0 - 1.0;
                    float atn = atan2(node_3528.g, node_3528.r);
                    float node_7464 = lerp(atn / 6.28318530718, 1 - abs(atn / 3.14159265359), _Switch01_N - 1);
                    float2 node_4134 = i.time.g * float2(_02J_U, _02J_V) + float2(node_7464, distance(node_3528, float2(0,0))) + node_4589;
                    float4 node_4113 = tex2D(_EmiTex, TRANSFORM_TEX(node_4134, _EmiTex));

                    float2 node_9412 = node_6102 + float2(_Lerp0_U * node_4134.r, node_4134.r * _Lerp0_V);
                    float4 node_5111 = tex2D(_LerpTex, TRANSFORM_TEX(node_9412, _LerpTex));
                    float2 node_9099 = node_6102 + float2(_Lerp1_U * node_4134.r, node_4134.r * _Lerp1_V);
                    float4 _node_5111_copy = tex2D(_LerpTex, TRANSFORM_TEX(node_9099, _LerpTex));
                    
                    float3 emissive = _Color.rgb * _Tex_Value * lerp(node_5111.r, _node_5111_copy.g, _Lerp_Switch) * _Lerp_Value*node_4113.rgb;
                    float4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                    return float4(emissive * i.color.rgb, _Color.a * _MainTex_var.r * _Tex_Value * i.color.a);
                }
            }
            ENDCG
        }
    }

}

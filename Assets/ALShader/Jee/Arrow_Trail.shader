// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Jee/tempt/Arrow_Trail" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Speed ("Speed", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
        _rj ("rj", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            #pragma target 2.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _rj;
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
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
               
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float3 emissive = i.vertexColor.rgb;
                float3 finalColor = emissive;
                float4 node_1906 = _Time + _TimeEditor;
                float2 node_5290 = (i.uv0+float2((node_1906.g*_Speed),0.0));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_5290, _MainTex));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                fixed4 finalRGBA = fixed4(finalColor,(saturate((((i.vertexColor.a*2.0+-1.0)+_MainTex_var.r)*_rj))*_MainTex_var.r*_Mask_var.r));

                return finalRGBA;
            }
            ENDCG
        }
    }
   
}

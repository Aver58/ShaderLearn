Shader "Jee/tempt/Loft_Move" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _MainVar ("MainVar", Float ) = 0
        _Noise ("Noise", 2D) = "white" {}
        _RJ_Var ("RJ_Var", Float ) = 0
        _OFF_Move ("OFF_Move", Float ) = 0
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
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"

            #pragma target 2.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _MainVar;
            uniform sampler2D _Noise; uniform float4 _Noise_ST;
            uniform float _RJ_Var;
            uniform float _OFF_Move;
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
                VertexOutput o ;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );               
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {

////// Lighting:
                float node_2231 = (i.vertexColor.a*2.0+-1.0);
                float2 node_347 = (i.uv0+((_OFF_Move*node_2231)*2.0+-1.0)*float2(0,1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_347, _MainTex));
                float4 _Noise_var = tex2D(_Noise,TRANSFORM_TEX(i.uv0, _Noise));
                float3 finalColor = ((i.vertexColor.rgb*_MainTex_var.rgb*_MainVar)*saturate((_RJ_Var*(node_2231+_Noise_var.r))));
                fixed4 finalRGBA = fixed4(finalColor,1);            
                return finalRGBA;
            }
            ENDCG
        }
    }
}

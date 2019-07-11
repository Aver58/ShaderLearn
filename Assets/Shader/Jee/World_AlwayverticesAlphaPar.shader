// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Jee/World/AlwayverticesAlphaPar" {
    Properties {
        _MainTex ("Main", 2D) = "white" {}
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
            //Tags {
            //    "LightMode"="ForwardBase"
            //}
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
             ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;

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
                o.uv0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }

            fixed4 frag(VertexOutput i) : COLOR {

                fixed4 _Main_var = tex2D(_MainTex,i.uv0);
                fixed3 finalColor = (_Main_var.r*i.vertexColor.rgb);
                fixed4 finalRGBA = fixed4(finalColor,(_Main_var.b*i.vertexColor.a));
                return finalRGBA;
            }
            ENDCG
        }
    }
}

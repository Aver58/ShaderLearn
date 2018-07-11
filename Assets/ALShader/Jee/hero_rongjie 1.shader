
Shader "Diy/Hero/liangbu_rongjie" {
    Properties {
        _node_8723 ("node_8723", 2D) = "white" {}
        _node_8113 ("node_8113", 2D) = "white" {}
        _node_788 ("node_788", Color) = (0.5,0.5,0.5,1)
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
            uniform sampler2D _node_8723; uniform float4 _node_8723_ST;
            uniform sampler2D _node_8113; uniform float4 _node_8113_ST;
            uniform float4 _node_788;
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
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
              
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

                float4 _node_8723_var = tex2D(_node_8723,TRANSFORM_TEX(i.uv0, _node_8723));
                float3 emissive = (i.vertexColor.rgb+_node_8723_var.rgb+_node_788.rgb);
                float3 finalColor = emissive;
                float4 _node_8113_var = tex2D(_node_8113,TRANSFORM_TEX(i.uv0, _node_8113));
                fixed4 finalRGBA = fixed4(finalColor,((i.vertexColor.a*_node_8723_var.b)*_node_8113_var.r));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

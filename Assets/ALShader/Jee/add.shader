Shader "ShaderForge/add" {
    Properties {
        _node_1878 ("node_1878", 2D) = "white" {}
        _node_8832 ("node_8832", Color) = (1,1,1,1)
        _node_9189 ("node_9189", Float ) = 1
        _node_4090 ("node_4090", 2D) = "white" {}
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
            uniform sampler2D _node_1878; uniform float4 _node_1878_ST;
            uniform float4 _node_8832;
            uniform sampler2D _node_4090; uniform float4 _node_4090_ST;
            uniform float _node_9189;
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
                o.pos = UnityObjectToClipPos( v.vertex );
         
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

////// Lighting:
////// Emissive:
                float4 _node_1878_var = tex2D(_node_1878,TRANSFORM_TEX(i.uv0, _node_1878));
                float4 _node_4090_var = tex2D(_node_4090,TRANSFORM_TEX(i.uv0, _node_4090));
                float3 emissive = ((_node_1878_var.rgb*i.vertexColor.rgb*i.vertexColor.a*_node_8832.rgb*_node_8832.a)*_node_9189*_node_4090_var.rgb);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
              
                return finalRGBA;
            }
            ENDCG
        }
    }
}


Shader "ShaderForge/alpha-blende" {
    Properties {
        _node_8723 ("node_8723", 2D) = "white" {}
        _node_788 ("node_788", Color) = (0.5,0.5,0.5,1)
        _node_5066 ("node_5066", 2D) = "white" {}
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
            uniform float4 _node_788;
            uniform sampler2D _node_5066; uniform float4 _node_5066_ST;
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

                float4 _node_8723_var = tex2D(_node_8723,TRANSFORM_TEX(i.uv0, _node_8723));
                float3 emissive = (_node_788.rgb*_node_8723_var.rgb*i.vertexColor.rgb);
                float3 finalColor = emissive;
                float4 _node_5066_var = tex2D(_node_5066,TRANSFORM_TEX(i.uv0, _node_5066));
                fixed4 finalRGBA = fixed4(finalColor,((i.vertexColor.a*_node_8723_var.b)*_node_5066_var.r*1.4));
             
                return finalRGBA;
            }
            ENDCG
        }
    }

}

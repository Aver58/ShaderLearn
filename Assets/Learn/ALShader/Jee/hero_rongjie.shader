//
Shader "ShaderForge/alpha-dissolution" {
    Properties {
        _node_8723 ("node_8723", 2D) = "white" {}
        _node_3125 ("node_3125", 2D) = "white" {}
        _node_4098 ("node_4098", Range(0, 5)) = 0.8912671
        _node_6235 ("node_6235", Range(0, 1)) = 0
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
            uniform sampler2D _node_3125; uniform float4 _node_3125_ST;
            uniform float _node_4098;
            uniform float _node_6235;
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

                float4 _node_3125_var = tex2Dlod(_node_3125,float4(TRANSFORM_TEX(i.uv0, _node_3125),0.0,_node_6235));
                clip((_node_3125_var.r*_node_4098) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = i.vertexColor.rgb;
                float3 finalColor = emissive;
                float4 _node_8723_var = tex2D(_node_8723,TRANSFORM_TEX(i.uv0, _node_8723));
                fixed4 finalRGBA = fixed4(finalColor,(_node_8723_var.r*i.vertexColor.a));
   
                return finalRGBA;
            }
            ENDCG
        }
    }

}

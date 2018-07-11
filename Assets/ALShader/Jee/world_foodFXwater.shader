// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Jee/World/foodFXwater" {
    Properties {
        _Speed ("Speed", Float ) = 0
        _MainTex ("Main", 2D) = "white" {}
        _Tiling ("Tiling", Float ) = 0.75
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            #pragma target 2.0
            #pragma multi_compile_fog
  
         
            float _Speed;
            sampler2D _MainTex; 
            float4 _MainTex_ST;
            float _Tiling;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };

            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.uv0.xy = v.texcoord0;
                o.uv0.zw = float2(1.0,_Tiling) * o.uv0.xy + float2(0.0,(_Time.y * _Speed));
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            
            fixed4 frag(VertexOutput i) : COLOR {
                float4 node_8733 = tex2D(_MainTex,TRANSFORM_TEX(i.uv0.zw, _MainTex));
                float4 node_1846 = tex2D(_MainTex,TRANSFORM_TEX(i.uv0.xy, _MainTex));
                float node_7914 = ((node_8733.r * i.vertexColor.r) + (node_1846.g * i.vertexColor.g * i.vertexColor.a));
                float3 finalColor = float3(node_7914,node_7914,node_7914);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,0));
                return finalRGBA;
            }
            ENDCG
        }
    }
}

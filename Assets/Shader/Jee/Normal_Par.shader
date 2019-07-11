// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Jee/City/Par" {
    Properties {
    	_Color("Color Tint", Color) = (0.5, 0.5, 0.5, 0.5)
        _MainTex ("_Main", 2D) = "white" {}
    }
    SubShader {
          Tags {

            "Queue"="Transparent"
      //    "RenderType"="Transparent"
        }
        Pass {
      
            //Tags {          
            //     "LightMode"="ForwardBase"
            // }

            Cull off
       
   			ZWrite Off 
            Blend SrcAlpha One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"
        
         
        
            uniform sampler2D _MainTex; 
            uniform float4 _MainTex_ST;
            uniform float4 _Color;

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
                o.uv0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
        
                float4 Main_var = tex2D(_MainTex,i.uv0);
                float3 emissive = (Main_var.rgb*i.vertexColor.rgb * i.vertexColor.a* _Color.rgb*Main_var.a);
                float4 finalColor = float4(emissive,1) ;
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"

}

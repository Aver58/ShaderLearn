// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Jee/Normal/Alpha2TexCull" {
    Properties {
  		_Color ("_Color", Color) = (1,1,1,1)
        _MainTex ("_MainTex", 2D) = "white" {}
        _AlphaTex ("_AlphaTex", 2D) = "white" {}      
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
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag      
            #include "UnityCG.cginc"
            #pragma target 2.0
            uniform sampler2D _MainTex; uniform fixed4 _MainTex_ST;
            uniform fixed4 _Color;
            uniform sampler2D _AlphaTex; uniform fixed4 _AlphaTex_ST;
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
            fixed4 frag(VertexOutput i) : COLOR {

                fixed4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                fixed3 finalColor = (_Color.rgb*_MainTex_var.rgb);
                fixed4 _AlphaTex_var = tex2D(_AlphaTex,TRANSFORM_TEX(i.uv0, _AlphaTex));
                fixed4 finalRGBA = fixed4(finalColor*i.vertexColor.rgb ,_AlphaTex_var.g*i.vertexColor.a );
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

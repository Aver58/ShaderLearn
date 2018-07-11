// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Jee/City/BudlingMap" {
    Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _lightmap ("lightmap", 2D) = "white" {}
        _node_7724 ("node_7724", Color) = (1,0.9340771,0.8161765,1)
        _node_5893 ("node_5893", Color) = (0.04541522,0.1005488,0.1764706,1)     
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Geometry+100"
        }
        Pass {
            Blend One OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            #pragma target 2.0
			fixed4 _Color;

            sampler2D _MainTex; 
            float4 _MainTex_ST;
            sampler2D _lightmap; 
            float4 _lightmap_ST;

            fixed4 _node_7724;
            fixed4 _node_5893;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.uv0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.uv0.zw = TRANSFORM_TEX(v.texcoord1, _lightmap);
                o.pos = UnityObjectToClipPos(v.vertex);
   
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                fixed4 _mainCol = tex2D(_MainTex, i.uv0.xy);
                fixed3 albedo = (_node_7724.rgb * _mainCol.rgb);

                fixed4 _lightCol = tex2D(_lightmap, i.uv0.zw);
                fixed3 emissive = (albedo * _lightCol.rgb);

                fixed3 _mainCol2x = (_mainCol.rgb * _mainCol.rgb);
                fixed3 _diffuse = ((_mainCol2x + _node_5893.rgb) * 1.5 - 0.5) * _Color.rgb;
                fixed3 finalColor = emissive + saturate(_diffuse);
                UNITY_APPLY_FOG(i.fogCoord, finalColor);
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
   FallBack "SoarD/SoarD_Diffuse"
}

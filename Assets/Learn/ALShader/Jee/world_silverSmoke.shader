// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Jee/World/silverSmoke" {
    Properties {
    	_Alpha("_Alphamap", 2D) = "white" {}
        _MainTex ("Main", 2D) = "white" {}
        _ColR ("ColR", Color) = (0.2941177,0.2941177,0.2941177,1)
        _Speed ("Speed", Float ) = 0
        _ColB ("ColB", Color) = (0,0,0,1)
        _ColG ("ColG", Color) = (1,1,1,1)
        _ColorButtom ("ColorButtom", Color) = (0.8588236,0.7843138,0.6196079,1)
        _ColorTop ("ColorTop", Color) = (0.8078432,0.7843138,0.7843138,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent+500"
            "RenderType"="Transparent"
        }
        Pass {

            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
     
            #include "UnityCG.cginc"
  		 	#pragma target 2.0
            #pragma multi_compile_fog
       
            fixed4 _ColR;
            fixed _Speed;
            fixed4 _ColB;
            fixed4 _ColG;
            fixed4 _ColorButtom;
            fixed4 _ColorTop;
            sampler2D _MainTex; 
            fixed4 _MainTex_ST;
            sampler2D _Alpha; 
            fixed4 _Alpha_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;             
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0; 
                float2 alphaUV : TEXCOORD2;             
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.pos = UnityObjectToClipPos(v.vertex );

                o.alphaUV = TRANSFORM_TEX(v.texcoord0, _Alpha);

                float2 offset1 = v.texcoord0 * float2(1, 2) + float2(0, _Speed * _Time.y);
                float2 offset2 = v.texcoord0 + float2(0, _Speed * _Time.y);

                o.uv.xy = TRANSFORM_TEX(offset1, _MainTex);
                o.uv.zw = TRANSFORM_TEX(offset2, _MainTex);

                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            fixed4 frag(VertexOutput i) : COLOR {     
            	fixed _AlphaVar = tex2D(_Alpha, i.alphaUV).r;
                              
                fixed4 node_7512 = tex2D(_MainTex,i.uv.xy);
                fixed4 node_9436 = tex2D(_MainTex,i.uv.zw);
                fixed3 finalColor = lerp(_ColorButtom.rgb, _ColorTop.rgb, ((_ColB.rgb*node_7512.b) + (_ColR.rgb * node_9436.r) + (node_7512.g * _ColG.rgb)));
                fixed4 finalRGBA = fixed4(finalColor,(node_7512.b + node_9436.r + node_7512.g) * _AlphaVar);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
}

Shader "Jee/Role/BattleMaterial" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _LightPos_01 ("LightPos_01", Vector) = (0,0,0,0)
        _LightPos_02 ("LightPos_02", Vector) = (0,0,0,0)
        _LightPos_03 ("LightPos_03", Vector) = (0,0,0,0)
        _Col_01 ("Col_01", Color) = (0.5,0.5,0.5,1)
        _Col_02 ("Col_02", Color) = (0.5,0.5,0.5,1)
        _Col_03 ("Col_03", Color) = (0.5,0.5,0.5,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque" 
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }          
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
			#include "Assets/Shader/AL.cginc"

            #pragma target 2.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _LightPos_01;
            uniform float4 _LightPos_02;
            uniform float4 _LightPos_03;
            uniform float4 _Col_01;
            uniform float4 _Col_02;
            uniform float4 _Col_03;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normalDir : TEXCOORD1;         
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (_MainTex_var.rgb*((max(0,dot(normalize(_LightPos_01.rgb),i.normalDir))*_LightPos_01.a*_Col_01.rgb)+(max(0,dot(normalize(_LightPos_02.rgb),i.normalDir))*_LightPos_02.a*_Col_02.rgb)+(max(0,dot(normalize(_LightPos_03.rgb),i.normalDir))*_LightPos_03.a*_Col_03.rgb)));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                return GetBrightnessColor(finalRGBA);
            }
            ENDCG
        }
    }
}

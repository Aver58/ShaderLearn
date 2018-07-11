Shader "Jee/World/et_accact_Trail" {
    Properties {
        _value ("value", Float ) = 0
        _RColor ("RColor", Color) = (0.5,0.5,0.5,1)
        _GColor ("GColor", Color) = (0.5,0.5,0.5,1)
        _Tail ("Tail", Float ) = 0
        _timer ("timer", Float ) = 0
        _Distortion ("Distortion", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _MainTex ("MainTex", 2D) = "white" {}
        _Power ("Power", Float ) = 0
        _TopTime ("TopTime", Float ) = 0
        _Opacity ("Opacity", Float ) = 0
        _TopColor ("TopColor", Color) = (0.5,0.5,0.5,1)
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
            uniform float4 _TimeEditor;
            uniform float _value;
            uniform float4 _RColor;
            uniform float4 _GColor;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Tail;
            uniform float _timer;
            uniform sampler2D _Distortion; uniform float4 _Distortion_ST;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Power;
            uniform float _TopTime;
            uniform float _Opacity;
            uniform float4 _TopColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
                float4 node_328 = _Time + _TimeEditor;
                float2 node_8060 = (i.uv0+(_TopTime*node_328.g)*float2(1,0));
                float4 node_5791 = tex2D(_Distortion,TRANSFORM_TEX(node_8060, _Distortion));
                float node_4032 = 0.0;
                float2 node_24 = (i.uv0+float2((node_5791.r*_Power),node_4032));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_24, _MainTex));
                float4 node_612 = _Time + _TimeEditor;
                float2 node_879 = (i.uv0+(_timer*node_612.g)*float2(1,0));
                float4 node_3037 = tex2D(_Distortion,TRANSFORM_TEX(node_879, _Distortion));
                float2 node_9492 = (i.uv0+float2((node_3037.r*_Tail),node_4032));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(node_9492, _Mask));
                float3 finalColor = ((i.vertexColor.rgb*_MainTex_var.r*_TopColor.rgb)+(_value*i.vertexColor.rgb*(lerp(_RColor.rgb,_GColor.rgb,((1.0 - i.uv0.r)*2.0+-1.0))+_Mask_var.r)));
                fixed4 finalRGBA = fixed4(finalColor,(i.vertexColor.a*saturate(_Mask_var.r)*_Opacity));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        
        }
    }
   
}

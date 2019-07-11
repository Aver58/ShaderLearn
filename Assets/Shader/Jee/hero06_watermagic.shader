Shader "Jee/World/hero06_watermagic" {
    Properties {
        _MainVar ("MainVar", Vector) = (0,0,0,0)
        _Distoretion ("Distoretion", 2D) = "white" {}
        _disSpeed ("disSpeed", Float ) = 0
        _DisPower ("DisPower", Float ) = 0
        _NoiseVar ("NoiseVar", Vector) = (0,0,0,0)
        _Lerp ("Lerp", Float ) = 0
        _add ("add", Float ) = 0
        _Power ("Power", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
        _MainTex ("MainTex", 2D) = "white" {}
        _Top ("Top", 2D) = "white" {}
        _TpoVar ("TpoVar", Vector) = (0,0,0,0)
        _AddColor ("AddColor", Color) = (0.5,0.5,0.5,1)
        _Opacity ("Opacity", Float ) = 0
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
            uniform float4 _MainVar;
            uniform sampler2D _Distoretion; uniform float4 _Distoretion_ST;
            uniform float _disSpeed;
            uniform float _DisPower;
            uniform float _Lerp;
            uniform float4 _NoiseVar;
            uniform float _add;
            uniform float _Power;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _Top; uniform float4 _Top_ST;
            uniform float4 _TpoVar;
            uniform float4 _AddColor;
            uniform float _Opacity;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 node_7486 = _Time + _TimeEditor;
                float2 node_5070 = (i.uv0+(_disSpeed*node_7486.g)*float2(0.2,1));
                float4 _Distoretion_var = tex2D(_Distoretion,TRANSFORM_TEX(node_5070, _Distoretion));
                float2 node_3315 = (i.uv0+float2((_MainVar.r*node_7486.g),(node_7486.g*_MainVar.g))+(_Distoretion_var.r*_DisPower));
                float4 node_5016 = tex2D(_MainTex,TRANSFORM_TEX(node_3315, _MainTex));
                float2 node_9022 = (i.uv0+float2((_NoiseVar.r*node_7486.g),(_NoiseVar.g*node_7486.g)));
                float4 node_4235 = tex2D(_MainTex,TRANSFORM_TEX(node_9022, _MainTex));
                float2 node_4526 = (node_9022+(_Distoretion_var.r*_TpoVar.a));
                float4 _Top_var = tex2D(_Top,TRANSFORM_TEX(node_4526, _Top));
                float3 emissive = ((_AddColor.rgb*_add)+lerp(pow((node_5016.rgb*_MainVar.b),_Power),(node_4235.rgb*_NoiseVar.b),_Lerp)+(_TpoVar.b*_Top_var.rgb));
                float3 finalColor = emissive;
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                fixed4 finalRGBA = fixed4(finalColor,(saturate((((node_5016.r+0.3)*_MainVar.a)+(node_4235.r*_NoiseVar.a)))*_Mask_var.r*_Opacity));

                return finalRGBA;
            }
            ENDCG
        }
    }
   
}

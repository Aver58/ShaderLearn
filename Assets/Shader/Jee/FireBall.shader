Shader "Jee/World/FireBall" {
    Properties {
        _MinOut ("MinOut", Float ) = 0
        _MaxOut ("MaxOut", Float ) = 0
        _power ("power", Float ) = 0
        _timer ("timer", Float ) = 0
        _colorTop ("colorTop", Color) = (0.5,0.5,0.5,1)
        _colorBtm ("colorBtm", Color) = (0.5,0.5,0.5,1)
        _distortion ("distortion", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
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
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
          
            #pragma target 2.0
            uniform float4 _TimeEditor;
            uniform float _MinOut;
            uniform float _MaxOut;
            uniform float _power;
            uniform float _timer;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float4 _colorTop;
            uniform float4 _colorBtm;
            uniform sampler2D _distortion; uniform float4 _distortion_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_2776 = _Time + _TimeEditor;
                float2 node_6547 = ((i.uv0*float2(0.6,0.6))+(_timer*node_2776.g)*float2(0,1));
                float4 node_2550 = tex2D(_distortion,TRANSFORM_TEX(node_6547, _distortion));
                float2 node_6426 = (i.uv0+(node_2550.r*_power));
                float4 node_417 = tex2D(_distortion,TRANSFORM_TEX(node_6426, _distortion));
                float node_2476 = smoothstep( _MinOut, _MaxOut, (1.0-max(0,dot(normalDirection, viewDirection))) );
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 node_7090 = (((node_417.rgb*node_2476)+node_2476)*_Mask_var.g);
                float3 emissive = (lerp(_colorBtm.rgb,_colorTop.rgb,node_7090)*node_7090);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
               
                return finalRGBA;
            }
            ENDCG
     
        }
    }
   
}

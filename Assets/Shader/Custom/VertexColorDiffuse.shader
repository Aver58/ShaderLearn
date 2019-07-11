Shader "Custom/VertexColorDiffuse" {
    Properties {
    	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    }

    SubShader {
        Tags {
            "Queue"="Transparent+100" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent"
        }
        
        Pass{
            Tags{"LightMode" = "ForwardBase"}

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite OFF

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Assets/Shader/AL.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                fixed3 sHSV = RGBtoHSV(col.rgb);
                sHSV.r = i.color.r;
                sHSV.g *= i.color.g * 2.0;
                sHSV.b *= i.color.b * 2.0;
                fixed3 retRGB = HSVtoRGB(sHSV);
                
                fixed4 lastColor = fixed4(retRGB, col.a);
                return lastColor;
            }
            ENDCG
        }
    }

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

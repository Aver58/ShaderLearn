Shader "Custom/Transparent/Diffuse(RGB+A)_Lambert_ChangeColor"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex", 2D) = "white" {}

		_HCorr ("H Correct", Range(0, 1)) = 0	//色调校正
		_SCorr ("S Correct", Range(0, 2)) = 1	//饱和度校正
		_VCorr ("V Correct", Range(0, 2)) = 1	//亮度校正
	}

    SubShader {
        Tags {
            "Queue"="Transparent+2" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent"
        }

        Pass{
            Tags{"LightMode" = "ForwardBase"}

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite OFF	
            Cull Off

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
            sampler2D _AlphaTex;

            float4 _MainTex_ST;
            float _HCorr;
            float _SCorr;
            float _VCorr;

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
                fixed3 col = tex2D(_MainTex, i.uv);
                fixed3 alpha = tex2D(_AlphaTex, i.uv);

                fixed3 sHSV = RGBtoHSV(col);
                sHSV.r = _HCorr;
                sHSV.g *= _SCorr;
                sHSV.b *= _VCorr;
                fixed3 retRGB = HSVtoRGB(sHSV);
                
                fixed4 lastColor = fixed4(lerp(retRGB, col, alpha.g), alpha.r) * i.color;
                return GetBrightnessColor(lastColor);
            }
            ENDCG
        }
    }
    Fallback "Legacy Shaders/Transparent/VertexLit"
}

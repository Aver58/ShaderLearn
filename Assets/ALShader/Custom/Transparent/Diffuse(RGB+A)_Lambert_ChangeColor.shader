Shader "Custom/Transparent/Diffuse(RGB+A)_Lambert_ChangeColor"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha Tex",2D) = "white" {}

		_SourceColor("Source Color", Color) = (1,1,1,1)
		_TargetColor("Target Color", Color) = (1,1,1,1)
		_HCorr ("H Correct", Range(0, 1)) = 0	//色调校正
		_SCorr ("S Correct", Range(0, 1)) = 0	//饱和度校正
		_VCorr ("V Correct", Range(0, 1)) = 0	//亮度校正
	}

    SubShader {
        Tags {"Queue"="Transparent+2" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 200

        Cull Off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade vertex:vert

		fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _AlphaTex;

        fixed4 _SourceColor; 
		fixed4 _TargetColor; 
		float _HCorr;
		float _SCorr;
		float _VCorr;

        struct Input {
            float2 uv_MainTex;
            float4 color;
        };

        void vert(inout appdata_full v, out Input o)  
        {  
            UNITY_INITIALIZE_OUTPUT(Input,o);

            o.color = v.color;
        } 

        fixed3 RGBtoHSV(fixed3 c)
	    {
	        fixed4 K = fixed4(0, -0.33, 2 * 0.33, -1);
	        fixed4 p = lerp(fixed4(c.bg, K.wz), fixed4(c.gb, K.xy), step(c.b, c.g));
	        fixed4 q = lerp(fixed4(p.xyw, c.r), fixed4(c.r, p.yzx), step(p.x, c.r));
	        fixed  d = q.x - min(q.w, q.y);

			fixed reciprocal = 1 / q.x;
	        fixed h = abs(q.z + (q.w - q.y) * 0.17);
	        fixed s = d * reciprocal;
	        fixed v = q.x;
			return fixed3(h, s, v);
	    }

	    fixed3 HSVtoRGB(fixed3 c)
	    {
	        fixed4 K = fixed4(1, 2 * 0.33, 0.33, 3);
	        fixed3 p = abs(frac(c.xxx + K.xyz) * 6 - K.www);
	        return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
	    }

        void surf (Input IN, inout SurfaceOutput o) {
            fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed a = tex2D(_AlphaTex, IN.uv_MainTex);

            fixed3 mHSV = RGBtoHSV(c);
            fixed3 sHSV = RGBtoHSV(_SourceColor.rgb);
            fixed3 tHSV = RGBtoHSV(_TargetColor.rgb);

            fixed diffHue = abs(mHSV.x-sHSV.x);
            diffHue = lerp(diffHue,abs(diffHue - 1),step(0.5, diffHue));

            fixed factor = step(diffHue, _HCorr);
            factor = factor + step(abs(mHSV.y-sHSV.y),_SCorr);

//            factor = factor + step(abs(mHSV.z-sHSV.z),_VCorr); //使用_VCorr  iOS下 shader会编译不过 如果将_VCorr换成一个定值就可以，如下一行：
            factor = factor + step(abs(mHSV.z-sHSV.z),0.75);   //使用一个定值就可以

            factor = step(3,factor);
            fixed3 ret = HSVtoRGB(mHSV + (tHSV - sHSV));

			fixed3 col = lerp(c.rgb, ret, factor) * a;

            o.Albedo = col;
            o.Alpha = a*IN.color.a;
        }

        ENDCG
    }

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

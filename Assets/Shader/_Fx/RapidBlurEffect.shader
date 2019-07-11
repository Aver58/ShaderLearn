Shader "Hidden/RapidBlurEffect" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}

	SubShader{

		Pass{
			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;

			float4 _MainTex_ST;//TRANSFORM_TEX 必需品
			float4 _MainTex_TexelSize;
			float _blurSize;

			struct a2v{
				float2 uv : TEXCOORD0;
				float4 vertex : POSITION;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 offsetuv[4] : TEXCOORD1;
			};

			v2f vert(a2v IN){
				v2f o;
				o.pos = UnityObjectToClipPos(IN.vertex);
				// 处理UV的till和offset
				o.uv = TRANSFORM_TEX(IN.uv, _MainTex);

				// 为啥这个常量放在顶点函数外面效果差这么多？？？todo
				float2 offsetWeight[4] = {
					float2(0, 1),
					float2(-1, 0),
					float2(1, 0),
					float2(0, -1)
				};
				// 取周围4个像素做模糊
				o.offsetuv[0] = o.uv.xy + float2(offsetWeight[0].x, offsetWeight[0].y) * _MainTex_TexelSize * _blurSize;
				o.offsetuv[1] = o.uv.xy + float2(offsetWeight[1].x, offsetWeight[1].y) * _MainTex_TexelSize * _blurSize;
				o.offsetuv[2] = o.uv.xy + float2(offsetWeight[2].x, offsetWeight[2].y) * _MainTex_TexelSize * _blurSize;
				o.offsetuv[3] = o.uv.xy + float2(offsetWeight[3].x, offsetWeight[3].y) * _MainTex_TexelSize * _blurSize;

				return o;
			}

			fixed4 frag(v2f IN) : SV_TARGET{
				fixed4 col = fixed4(0, 0, 0, 0);
				// 取样4个像素，然后*0.25 得出平均值
				col += tex2D(_MainTex, IN.offsetuv[0]);
				col += tex2D(_MainTex, IN.offsetuv[1]);
				col += tex2D(_MainTex, IN.offsetuv[2]);
				col += tex2D(_MainTex, IN.offsetuv[3]);
				col *= 0.25;
				col.a = 1;
				return col;
			}

			ENDCG
		}
	}

//		CGINCLUDE
//
//		#include "UnityCG.cginc"  
//
//		sampler2D _MainTex;
//
//		uniform half4 _MainTex_TexelSize;
//		uniform float _blurSize;
//
//		// weight curves  
//
//		static const half curve[4] = { 0.0205, 0.0855, 0.232, 0.324 };
//		static const half4 coordOffs = half4(1.0h, 1.0h, -1.0h, -1.0h);
//
//	struct v2f_withBlurCoordsSGX
//	{
//		float4 pos : SV_POSITION;
//		half2 uv : TEXCOORD0;
//		half4 offs[3] : TEXCOORD1;
//	};
//
//
//	v2f_withBlurCoordsSGX vertBlurHorizontalSGX(appdata_img v)
//	{
//		v2f_withBlurCoordsSGX o;
//		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
//
//		o.uv = v.texcoord.xy;
//		half2 netFilterWidth = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _blurSize;
//		half4 coords = -netFilterWidth.xyxy * 3.0;
//
//		o.offs[0] = v.texcoord.xyxy + coords * coordOffs;
//		coords += netFilterWidth.xyxy;
//		o.offs[1] = v.texcoord.xyxy + coords * coordOffs;
//		coords += netFilterWidth.xyxy;
//		o.offs[2] = v.texcoord.xyxy + coords * coordOffs;
//
//		return o;
//	}
//
//	v2f_withBlurCoordsSGX vertBlurVerticalSGX(appdata_img v)
//	{
//		v2f_withBlurCoordsSGX o;
//		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
//
//		o.uv = v.texcoord.xy;
//		half2 netFilterWidth = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _blurSize;
//		half4 coords = -netFilterWidth.xyxy * 3.0;
//
//		o.offs[0] = v.texcoord.xyxy + coords * coordOffs;
//		coords += netFilterWidth.xyxy;
//		o.offs[1] = v.texcoord.xyxy + coords * coordOffs;
//		coords += netFilterWidth.xyxy;
//		o.offs[2] = v.texcoord.xyxy + coords * coordOffs;
//
//		return o;
//	}
//
//	half4 fragBlurSGX(v2f_withBlurCoordsSGX i) : SV_Target
//	{
//		half2 uv = i.uv;
//
//		half4 color = tex2D(_MainTex, i.uv) * curve[3];
//
//		for (int l = 0; l < 3; l++)
//		{
//			half4 tapA = tex2D(_MainTex, i.offs[l].xy);
//			half4 tapB = tex2D(_MainTex, i.offs[l].zw);
//			color += (tapA + tapB) * curve[l];
//		}
//
//		return color;
//
//	}
//
//		ENDCG
//
//		SubShader {
//		ZTest Off  ZWrite Off Blend Off
//
//
//
//			Pass{
//			ZTest Always
//
//
//			CGPROGRAM
//
//			#pragma vertex vertBlurVerticalSGX  
//			#pragma fragment fragBlurSGX  
//
//			ENDCG
//		}
//
//
//			Pass{
//			ZTest Always
//
//
//			CGPROGRAM
//
//			#pragma vertex vertBlurHorizontalSGX  
//			#pragma fragment fragBlurSGX  
//
//			ENDCG
//		}
//	}
//
//	FallBack Off
}
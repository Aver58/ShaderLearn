Shader "_Aver3/20190710FastBlur"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_blurSize ("Blur Size", Range(0,10)) = 1.0
	}
	SubShader
	{
	    // 透明队列，在所有不透明的几何图形后绘制
		Tags { "RenderType"="Transparent" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma target 3.0

			#include "UnityCG.cginc"

			float _blurSize;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;

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
			
			fixed4 frag (v2f IN) : SV_Target
			{
				fixed4 col = fixed4(0, 0, 0, 0);
				// 取样4个像素，然后*0.25 得出平均值
				col += tex2D(_MainTex, IN.offsetuv[0]);
				col += tex2D(_MainTex, IN.offsetuv[1]);
				col += tex2D(_MainTex, IN.offsetuv[2]);
				col += tex2D(_MainTex, IN.offsetuv[3]);
				col *= 0.25;
				col.a = 1;
				// sample the texture
				// fixed4 col = tex2D(_MainTex, i.uv);

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}

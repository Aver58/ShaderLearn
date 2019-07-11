Shader "AL/ZBuf_Mask"
{
	SubShader
	{
		Tags { 
			"IgnoreProjector"="True"
			"RenderType"="Opaque" 
			"Queue"="Geometry-1"
			"LightMode"="ForwardBase"
		}

		ZWrite On
		ColorMask 0

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (float4 v : POSITION)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return 1;
			}
			ENDCG
		}
	}
}

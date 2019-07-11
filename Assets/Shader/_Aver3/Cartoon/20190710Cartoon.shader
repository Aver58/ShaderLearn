Shader "_Aver3/20190710Cartoon" {
	Properties 
	{
		_Outline("Outline",Range(0,1)) = 0.1
		_OutlineColor("Outline Color",Color) = (0,0,0,1)
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecularScale("Specular Scale",Range(0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		// 第一个Pass 用来渲染黑色描边
		Pass
		{
			NAME "OUTLINE"

			Cull Front
			Lighting Off
			ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _Outline;
			float4 _OutlineColor;

			struct v2f
            {
                float4 pos : POSITION;
            };

			v2f vert (appdata_full v): SV_POSITION
			{
				//return UnityObjectToClipPos(v.vertex + v.normal * _Outline);
				//扁平化背面
				v2f o;
				//把顶点位置转换到视角坐标系；
				float4 pos = mul( UNITY_MATRIX_MV, v.vertex); 
				//把法线转换到视角坐标系；
				float3 normal = mul( (float3x3)UNITY_MATRIX_IT_MV, v.normal);  
				//把转换后的法线的z值扁平化，使其是一个较小的定值，这样所有的背面其实都在一个平面上；
				normal.z = -0.5;
				//按描边的宽度放缩法线，并添加到转换后顶点的位置上，得到新的视角坐标系中的位置；
				pos = pos + float4(normalize(normal),0) * _Outline;
				//把新的位置转换到投影坐标系中。
				o.pos = mul(UNITY_MATRIX_P, pos);
				return o;
			}
			
			fixed4 frag () : SV_Target
			{
				return _OutlineColor;
			}

			ENDCG
		}

		// 第二个Pass用来渲染模型本身
		Pass
		{
			NAME "LIGHT MODEL"
			//定义光照模式，只有正确定光照模式，才能得到一些Unity内置光照变量
			Tags{"LightMode" = "ForwardBase"}

			Cull Back

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR;
				fixed3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			/*
			struct appdata_full {
			    float4 vertex : POSITION;
			    float4 tangent : TANGENT;
			    float3 normal : NORMAL;
			    float4 texcoord : TEXCOORD0;
			    float4 texcoord1 : TEXCOORD1;
			    float4 texcoord2 : TEXCOORD2;
			    float4 texcoord3 : TEXCOORD3;
			    fixed4 color : COLOR;
			};
			*/
			fixed _SpecularScale;
			fixed3 _SpecularColor;
			float4 _MainTex_ST;//为了可以使用TRANSFORM_TEX

			v2f vert(appdata_full v)
			{
				v2f o;
				o.color = v.color;
				o.normal = UnityObjectToWorldDir(v.normal);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul(i.normal,(float3x3)unity_WorldToObject));
				//得到世界空间内的光线方向
				fixed3 worldLight = _WorldSpaceLightPos0.xyz;
				fixed spec = dot(worldNormal,worldLight);
				spec = lerp(_SpecularScale, 1.0, step(_SpecularScale, spec));
				return fixed4(ambient + spec * _SpecularColor.rgb,1.0);
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}


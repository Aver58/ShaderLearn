//20180520 Blinn-Phong逐像素
Shader "_Aver3/Blinn-Phong Specular Pixel-Level"
{
	Properties
	{
		_Diffuse("DiffuseColor",Color)=(1,1,1,1)
		_Specular("SpecualrColor",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8.0,256))=20
	}
	SubShader
	{
		Pass
		{
		Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct v2f
			{
				float4 pos:SV_POSITION;
				fixed3 worldNormal : TEXCOORD0;
				fixed3 viewDir : TEXCOORD1;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);//normalize(mul(v.normal,(float3x3)unity_WorldToObject));
	
				//计算世界空间下的观察方向
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = normalize(i.worldNormal);

				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLightDir));
				
				fixed3 viewDir = i.viewDir;
				fixed3 halfDir = normalize(worldLightDir+viewDir);
				// 计算高光反射部分
				// 高光 = （入射光 * 高光反射系数） * （max（0，法线方向·h矢量））^ 高光指数
				// h矢量 = (视角方向 + 光照方向) / 视角方向 + 光照方向 的模
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(halfDir, worldNormal)), _Gloss);
				return fixed4(ambient+diffuse+specular,1.0);
			}
			ENDCG
		}
	}
}

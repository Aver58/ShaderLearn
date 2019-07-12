//520.5逐像素高光

Shader "_Aver3/Specular Pixel-Level"
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
				fixed3 normal : TEXCOORD0;
				fixed3 viewDir : TEXCOORD1;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = UnityObjectToWorldNormal(i.normal);

				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLightDir));

				//通过CG提供的reflect(i,n)提供的函数计算反射方向
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				fixed3 viewDir = i.viewDir;
				//计算高光反射部分
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(viewDir, reflectDir)), _Gloss);
				return fixed4(ambient+diffuse+specular,1.0);
			}
			ENDCG
		}
	}
}

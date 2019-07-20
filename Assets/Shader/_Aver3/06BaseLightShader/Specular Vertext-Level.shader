// 20180520逐顶点高光实现
Shader "_Aver3/Specular Vertext-Level"
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
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
					// Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				// Transform the normal from object space to world space
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				// Get the light direction in world space
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				// Compute diffuse term
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				
				//---------------  Start Specualr Part calculate  ---------------  

				// Get the reflect direction in world space(入射方向要求是光源指向交点处，所以对worldLightDir取反？？)
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				// Get the view direction in world space 视角方向：摄像机位置矢量减顶点矢量，得到视角矢量
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				
				// Compute specular term
				// 高光 = （入射光 * 高光反射系数） * （max（0，视角方向·反射方向））^ 高光指数
				// saturate(dot(reflectDir, viewDir)这里为啥要做点积呀？
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
				
				o.color = ambient + diffuse + specular;
							 	
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}
			ENDCG
		}
	}
}

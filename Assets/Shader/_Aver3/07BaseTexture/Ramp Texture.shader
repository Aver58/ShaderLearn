Shader "_Aver3/Ramp Texture"
{
	Properties
	{
		_RampTex ("Ramp Tex", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader
	{
		Tags{"LightMode" = "ForwardBase"}

		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TangentToWorld0 : TEXCOORD1;
				float4 TangentToWorld1 : TEXCOORD2;
				float4 TangentToWorld2 : TEXCOORD3;
			};

			sampler2D _RampTex;
			float4 _RampTex_ST;
			float4 _Color;
			float4 _Specular;
			float _Gloss;
			
			v2f vert (appdata_tan v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

				return o;
			}
			
			// 得到切线空间法线方向，
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPos = float3(i.TangentToWorld0.w,i.TangentToWorld1.w,i.TangentToWorld2.w);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				//fixed3 tangentLightDir = normalize(i.lightDir);
				//fixed3 tangentViewDir = normalize(i.viewDir);
				//
				//// 获取法线贴图的像素
				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				//fixed3 tangentNormal;
				//// 如果纹理没有标记成法线贴图
				////tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpScale;
				////tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
				//
				//// 如果标记成了法线贴图，可以用内置函数
				fixed3 normal = UnpackNormal(packedNormal);
				normal.xy *= _BumpScale;
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				// 把法线从切线空间转到世界空间
				normal = normalize(fixed3(dot(i.TangentToWorld0.xyz,normal),dot(i.TangentToWorld1.xyz,normal),dot(i.TangentToWorld2.xyz,normal)));

				//使用tex2D做纹理采样，将采样结果和颜色属性_Color相乘作为反射率
				fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(normal,lightDir));
				
				fixed3 halfDir = normalize(lightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(halfDir,normal)), _Gloss);
				
				return fixed4(ambient + diffuse + specular,1.0);
			}
			ENDCG
		}
	}
}

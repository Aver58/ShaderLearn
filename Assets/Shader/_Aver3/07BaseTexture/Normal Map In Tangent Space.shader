Shader "_Aver3/Normal Map In Tangent Space"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		// bump是unity内置法线纹理，没提供的时候就对应了模型自带的法线信息
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Bump Scale", float) = 1.0
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
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float4 _Color;
			float4 _Specular;
			float _BumpScale;
			float _Gloss;
			
			v2f vert (appdata_tan v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);// xy存储了_MainTex的纹理坐标
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
				
				// 计算副法线 cross 叉积 * v.tangent.w W决定了方向
				float3 binormal = cross(normalize(v.normal),normalize(v.tangent.xyz)) * v.tangent.w;
				// 模型空间 ==》 切线空间
				float3x3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);
				// TANGENT_SPACE_ROTATION;
				// 切线空间的光线方向
				o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex).xyz);
				// 切线空间的摄像机方向
				o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex).xyz);
				return o;
			}
			
			// 得到切线空间法线方向，
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);
	
				// 纹理采样得到切线空间下法线
				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				fixed3 tangentNormal;
				// 如果纹理Texture Type 没有设置成法线贴图
				//tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpScale;
				//tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				// 如果标记成了法线贴图，可以用内置函数
				// packednormal.xyz * 2 - 1; z轴计算不一样
				tangentNormal = UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				// z由xy分量计算（sqr(1-xy^2)）todo  ???
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				//使用tex2D做纹理采样，将采样结果和颜色属性_Color相乘作为反射率
				fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
	
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
	
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal,tangentLightDir));
	
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(halfDir,tangentNormal)), _Gloss);
	
				return fixed4(ambient + diffuse + specular,1.0);
			}
			ENDCG
		}
	}
}

//2019.07.22 渐变纹理
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
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);
				return o;
			}
			
			// 得到切线空间法线方向，
			fixed4 frag (v2f i) : SV_Target
			{
				// 顶点和法线的normalize会有一丝区别
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed halfLambert = 0.5 * dot(worldNormal,worldLightDir) + 0.5;
				fixed3 albedo = tex2D(_RampTex,fixed2(halfLambert,halfLambert)).rgb * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * albedo;
				
				fixed3 halfDir = normalize(worldLightDir + worldViewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(halfDir,worldNormal)), _Gloss);
				
				return fixed4(ambient + diffuse + specular,1.0);
			}
			ENDCG
		}
	}
}

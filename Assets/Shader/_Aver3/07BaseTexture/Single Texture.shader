// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "_Aver3/Single Texture"
{
	Properties{
			_Color("Color",color) = (1,1,1,1)
			_MainTex("Main Tex", 2D) = "white"{}
			_Specular("Specular", color) = (1, 1, 1, 1)
			_Gloss("Gloss", Range(8.0, 256)) = 20
		}
		SubShader{
			Pass{
			Tags{"LightMode" = "ForwardBase"}
	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
	
			fixed4 _Color;
			sampler2D _MainTex;
			//纹理类型的属性需要再声明一个float4类型的变量，命名格式为 纹理名_ST 
			//其中，ST是缩放和偏移的缩写 纹理名_ST.xy存储的是缩放值，纹理名_ST.zw存储的是偏移值 //对应材质面板的纹理属性的Tiling和Offset调节项
			float4 _MainTex_ST;
			fixed4 _Specular;
			float   _Gloss;  
	
			struct v2f {
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
	
			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				//对纹理坐标进行变换，对应材质面板的Tiling和Offset调节项
				//o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex); 
	
				return o;
			}

			fixed4 frag(v2f i) :SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
	
				//使用tex2D做纹理采样，将采样结果和颜色属性_Color相乘作为反射率
				fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
	
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
	
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal,worldLightDir));
	
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(halfDir,worldNormal)), _Gloss);
	
				return fixed4(ambient + diffuse + specular,1.0);
			}
			ENDCG		
		}
	}

	Fallback "Specular"
}

//逐像素漫反射实现
Shader "_Aver3/Diffuse Pixel-Level"
{
	Properties{
		_Diffuse("DiffuseColor",Color) = (1.0,1.0,1.0,1.0)
	}
	
		SubShader{
		Pass{
		//定义光照模式，只有正确定光照模式，才能得到一些Unity内置光照变量
		Tags{ "LightMode" = "ForwardBase" }
	
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		//使用Unity的内置包含文件，使用其内置变量
		#include "Lighting.cginc"
	
		//定义与属性相同类型和相同名称的变量
		fixed4 _Diffuse;
	
		//定义顶点着色器输出结构体（片元着色器输入结构体）
		struct v2f {
			float4 pos:SV_POSITION;
			float3 worldNormal:TEXCOORD0;
		};
		
		v2f vert(appdata_base v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			//存储世界空间下的法线，传递给片元着色器，
			//只有顶点着色器才能接受来自模型空间的数据，因此需要先计算再传递给片元着色器
			o.worldNormal =mul(v.normal,unity_WorldToObject);
			return o;
		}
		
		fixed4 frag(v2f i) :SV_Target{
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			fixed3 worldNormal = normalize(i.worldNormal);
			fixed3 worldLight = normalize(_WorldSpaceLightPos0);
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));
		
			fixed3 color = diffuse + ambient;
			return fixed4(color,1.0);
		}
	
		ENDCG
	}
	
	}
	Fallback"Diffuse"

}

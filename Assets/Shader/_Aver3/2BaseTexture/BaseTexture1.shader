// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/BaseTexture1"
{
	Properties{
		_Color("Color",Color)=(1,1,1,1)
		_MainTex("MainTex",2D) ="white" {}
		//bump为Unity自带的法线纹理，当没有提供任何法线时，"bump"就对应模型自身的法线信息
		_BumpTex("Noraml Tex",2D) = "bump"{} 
		//BumpScale代表凹凸程度，值为0时，表示该法线纹理不会对光照产生任何影响
		_BumpScale("BumpScal",Float) = 1.0  
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
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
			float4 _MainTex_ST;
			sampler2D _BumpTex;
			float4 _BumpTex_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;  

			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				//tangent存储顶点的切线方向，float4类型，通过tangent.w分量决定副切线的方向性
				float4 tangent:TANGENT;   
				float4 texcoord:TEXCOORD0;
			};

			struct v2f {
				float4 pos:SV_POSITION;
				float4 uv:TEXCOORD0;
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy*_MainTex_ST.xy + _MainTex_ST.zw;//(uv.xy存储主纹理坐标变换后的uv坐标)
				o.uv.zw = v.texcoord.xy*_BumpTex_ST.xy + _BumpTex_ST.zw;//(uv.zw存储法线纹理坐标变换后的uv坐标)
				//_MainTex和_BumpTex通常会使用同一组纹理坐标（法线纹理贴图由对应纹理贴图生成） 

				float3 binormal = cross(normalize(v.normal),normalize(v.tangent.xyz))*v.tangent.w;
				float3x3 rotation = float3x3(v.tangent.xyz, binormal,v.normal);
				//(按行填充，得到的矩阵实际上是模型到切线的逆矩阵的转置矩阵，也就是模型到切线的转换矩阵(正交矩阵))
				//也可以使用内建宏TANGENT_SPACE_ROTATION得到变换矩阵 

				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			} 

			fixed4 frag(v2f i):SV_TARGET {
				fixed3  tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);  

				fixed4 packedNormal = tex2D(_BumpTex,i.uv.zw);  //对法线纹理进行采样
				fixed3 tangentNormal;
			    //若法线纹理类型没有被设置为bump类型，则进行手动反映射
				//tangentNormal=(packedNormal.xyz*2-1);
				//若已经设置为bump类型，可以使用内建函数
				tangentNormal = UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0-saturate(dot(tangentNormal.xy,tangentNormal.xy)));

				fixed3 albedo = _Color.rgb*tex2D(_MainTex,i.uv.xy);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));
				fixed3 halfDir = normalize(tangentLightDir+tangentViewDir);
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);

				return fixed4(ambient+diffuse+specular,1.0);
			}
		ENDCG
		}
	}
	FallBack "Specular"
}

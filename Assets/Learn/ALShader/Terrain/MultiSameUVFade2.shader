// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Terrain/MultiSameUVFade2" {
	Properties {
        _Color ("Main Tint", Color) = (1,1,1,1)
		
        _Control1 ("Control (RGBA)", 2D) = "white" {}
        _Control2 ("Control 2", 2D) = "white" {}
		_Splat1 ("Layer 1", 2D) = "white" {}
        _Splat2 ("Layer 2", 2D) = "white" {}
        _Splat3 ("Layer 3", 2D) = "white" {}
        _Splat4 ("Layer 4", 2D) = "white" {}
        _Splat5 ("Layer 5", 2D) = "white" {}
        _Splat6 ("Layer 6", 2D) = "white" {}

	}

	SubShader {

        Pass{
        	Tags {"LightMode"="ForwardBase" "Queue"="Transparent-100" "IgnoreProjector"="True" "RenderType"="Transparent"}

        	ZWrite Off
        	Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "Assets/Shader/AL.cginc"

			struct a2v{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 vertex : SV_POSITION;

				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD8;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				float2 uv4 : TEXCOORD6;
				float2 uv5 : TEXCOORD7;
				float2 uv6 : TEXCOORD9;

				fixed4 worldPos : TEXCOORD4;
				float4 normal : TEXCOORD5;
			};

	        sampler2D _Control1, _Control2;
	        sampler2D _Splat1,_Splat2,_Splat3,_Splat4, _Splat5, _Splat6;

	        float4 _Control1_ST, _Control2_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST, _Splat4_ST, _Splat5_ST, _Splat6_ST;

	        fixed4 _Color;

	        v2f vert(a2v v){
	        	v2f o;

	        	o.vertex = UnityObjectToClipPos(v.vertex);

	        	o.uv0 = TRANSFORM_TEX(v.texcoord, _Control1);
	        	o.uv1 = TRANSFORM_TEX(v.texcoord, _Splat1);
	        	o.uv2 = TRANSFORM_TEX(v.texcoord, _Splat2);
	        	o.uv3 = TRANSFORM_TEX(v.texcoord, _Splat3);
	        	o.uv4 = TRANSFORM_TEX(v.texcoord, _Splat4);
	        	o.uv5 = TRANSFORM_TEX(v.texcoord, _Splat5);
	        	o.uv6 = TRANSFORM_TEX(v.texcoord, _Splat6);

	        	o.worldPos = mul(unity_ObjectToWorld, v.vertex);

	        	o.normal.xyz = mul(v.normal, (float3x3)unity_WorldToObject);
	        	o.normal.w = v.vertex.y;

	        	return o;
	        }

	        fixed4 frag(v2f i) : SV_Target{

	        	fixed3 col_control1 = tex2D(_Control1, i.uv0).rgb;
	        	fixed3 col_control2 = tex2D(_Control2, i.uv0).rgb;

	        	fixed3 layer0 = tex2D(_Splat1, i.uv1).rgb;
	        	fixed3 layer1 = tex2D(_Splat2, i.uv2).rgb;

	        	fixed3 layer2 = tex2D(_Splat3, i.uv3).rgb;
	        	fixed3 layer3 = tex2D(_Splat4, i.uv4).rgb;

	        	fixed3 layer4 = tex2D(_Splat5, i.uv5).rgb;
	        	fixed3 layer5 = tex2D(_Splat6, i.uv6).rgb;

	        	fixed4 albedo = fixed4(1.0, 1.0, 1.0, 1.0);
	        	albedo.rgb = (layer0 * col_control1.r + layer1 * col_control1.g + layer2 * col_control1.b);
	        	albedo.rgb += (layer3 * col_control2.r + layer4 * col_control2.g + layer5 * col_control2.b);
	        	albedo.rgb *= _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;

	        	float3 worldNormal = normalize(i.normal).xyz;
//	
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);// normalize(WorldSpaceLightDir(i.worldPos));
	
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, lightDir));

				albedo.a = 0.2;

	        	fixed4 finalRGBA =  fixed4(ambient + diffuse, albedo.a);
				return GetBrightnessColor(finalRGBA);
	        }
			ENDCG
        }

        Pass{
        	Tags {"LightMode"="ForwardBase" "Queue"="Transparent-100" "IgnoreProjector"="True" "RenderType"="Transparent"}
        	
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "Assets/Shader/AL.cginc"

			struct a2v{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 vertex : SV_POSITION;

				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD8;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				float2 uv4 : TEXCOORD6;
				float2 uv5 : TEXCOORD7;
				float2 uv6 : TEXCOORD9;

				fixed4 worldPos : TEXCOORD4;
				float4 normal : TEXCOORD5;

				UNITY_FOG_COORDS(1)
			};

	        sampler2D _Control1, _Control2;
	        sampler2D _Splat1,_Splat2,_Splat3,_Splat4, _Splat5, _Splat6;

	        float4 _Control1_ST, _Control2_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST, _Splat4_ST, _Splat5_ST, _Splat6_ST;

	        fixed4 _Color;

	        v2f vert(a2v v){
	        	v2f o;

	        	o.vertex = UnityObjectToClipPos(v.vertex);

	        	o.uv0 = TRANSFORM_TEX(v.texcoord, _Control1);
	        	o.uv1 = TRANSFORM_TEX(v.texcoord, _Splat1);
	        	o.uv2 = TRANSFORM_TEX(v.texcoord, _Splat2);
	        	o.uv3 = TRANSFORM_TEX(v.texcoord, _Splat3);
	        	o.uv4 = TRANSFORM_TEX(v.texcoord, _Splat4);
	        	o.uv5 = TRANSFORM_TEX(v.texcoord, _Splat5);
	        	o.uv6 = TRANSFORM_TEX(v.texcoord, _Splat6);

	        	o.worldPos = mul(unity_ObjectToWorld, v.vertex);

	        	o.normal.xyz = mul(v.normal, (float3x3)unity_WorldToObject);
	        	o.normal.w = v.vertex.y;

	        	UNITY_TRANSFER_FOG(o,o.vertex);

	        	return o;
	        }

	        fixed4 frag(v2f i) : SV_Target{

	        	fixed3 col_control1 = tex2D(_Control1, i.uv0).rgb;
	        	fixed3 col_control2 = tex2D(_Control2, i.uv0).rgb;

	        	fixed3 layer0 = tex2D(_Splat1, i.uv1).rgb;
	        	fixed3 layer1 = tex2D(_Splat2, i.uv2).rgb;

	        	fixed3 layer2 = tex2D(_Splat3, i.uv3).rgb;
	        	fixed3 layer3 = tex2D(_Splat4, i.uv4).rgb;

	        	fixed3 layer4 = tex2D(_Splat5, i.uv5).rgb;
	        	fixed3 layer5 = tex2D(_Splat6, i.uv6).rgb;

	        	fixed4 albedo = fixed4(1.0, 1.0, 1.0, 1.0);
	        	albedo.rgb = (layer0 * col_control1.r + layer1 * col_control1.g + layer2 * col_control1.b);
	        	albedo.rgb += (layer3 * col_control2.r + layer4 * col_control2.g + layer5 * col_control2.b);
	        	albedo.rgb *= _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;

	        	float3 worldNormal = normalize(i.normal).xyz;
//	
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);// normalize(WorldSpaceLightDir(i.worldPos));
	
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, lightDir));

				albedo.a = smoothstep(-0.2, -0.1, i.normal.w);
				
	        	
//
				UNITY_APPLY_FOG(i.fogCoord, albedo);

//				return fixed4(1, , 1);

	        	fixed4 finalRGBA =  fixed4(ambient + diffuse, albedo.a);
				return GetBrightnessColor(finalRGBA);
	        }
			ENDCG
        }

	}
	FallBack "Diffuse"
}

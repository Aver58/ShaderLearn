// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Jee/World/WorldWater"{
    Properties{
        _Water_01 ("Normal Map (RGB), Foam (A)", 2D) = "white" {}
		_Water_02 ("Normal Map (RGB), Foam (B)", 2D) = "white" {}
		_MainTex ("ColorTex", 2D) = "white" {}	
		_WaveSpeed("Wave Speed", Float) = 0.4		
		_SpecularRatio ("Specular Ratio", Range(1,3)) = 1.5 
		_BottomColor("Bottom Color",Color) = (0,0,0,0)
		_TopColor("Top Color",Color) = (0,0,0,0)
		_ReflectionIntensity("Reflection Intensity", Range(0, 1)) = 0.1
        _LightAdd ("LightAdd", Range(1, 3)) = 2
        _SpecAdd ("SpecAdd", Range(0, 2)) = 0.35
        _Lerp ("Lerp", Range(0, 1)) = 0.5
        _WorldSpaceLightDir("LightDir",vector)=(0,0,0,0)
        _LightColor("_LightColor",Color) = (1,1,1,1)         
    }
    SubShader{
   
		Tags {
          	 "Queue"="AlphaTest+10"
			 "RenderType"="Transparent" 
			 "IgnoreProjector" = "True"
		  }   
		Pass{
		 
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite OFF	

			CGPROGRAM
			#pragma vertex Vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma target 2.0
			#include "UnityCG.cginc"

			sampler2D _Water_01;
			sampler2D _Water_02;
			float4 _Water_01_ST;
			float4 _Water_02_ST;
			sampler2D _MainTex;
			float4 _MainTex_ST; 
			float _WaveSpeed;
			float _SpecularRatio;
			float4 _BottomColor;
			float4 _TopColor;      
			float _ReflectionIntensity;             
			float4 _WorldSpaceLightDir;
			float3 _LightColor;
			float _LightAdd;
			float _SpecAdd;
			float _Lerp;

			struct VertexInput {
			    float4 vertex : POSITION;
			    float2 texcoord0 : TEXCOORD0;
			};
			struct v2f{
				float4 position : POSITION;
				float3 worldViewDir : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float4 time : TEXCOORD2;
			};

			v2f Vert(VertexInput v){
				v2f o;
				o.uv = v.texcoord0 ;
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldViewDir = UnityWorldSpaceViewDir(worldPos);
				o.position = UnityObjectToClipPos(v.vertex);
				o.time = _Time;
				return o;
			}

			fixed4 frag (v2f i) : COLOR{
				float3 light = _WorldSpaceLightDir;
				float3 lightColor = _LightColor.xyz * _LightAdd;
				fixed3 worldView = -normalize(i.worldViewDir);
				        
				fixed4 nmap1 = tex2D(_Water_01, TRANSFORM_TEX(i.uv.yx, _Water_01) + float2(i.time.x * _WaveSpeed, 0));
				fixed4 nmap2 = tex2D(_Water_02, TRANSFORM_TEX(i.uv.yx, _Water_02) - float2(i.time.x * _WaveSpeed, 0));
				fixed3 worldNormal  = normalize((nmap1.rgb + nmap2.rgb) * 2 - 2);
				float dotLightWorldNomal = dot(worldNormal, float3(0,1,0));

				float3 tmpSpec = pow(saturate(dot(worldNormal, normalize(worldView + light))),_SpecularRatio);
				float3 specularReflection = step(0, dotLightWorldNomal) * tmpSpec;

				fixed4 col;
				float fresnel = 0.5 * dotLightWorldNomal + 0.5;   
				col.rgb = lerp(_BottomColor.rgb, _TopColor.rgb, fresnel) * _ReflectionIntensity;         
				col.rgb += specularReflection * _SpecAdd;
				col.rgb *= lightColor; 
				    
				fixed4 shoreLineCol = tex2D(_MainTex,TRANSFORM_TEX(i.uv, _MainTex));
				fixed3 color = lerp(col.rgb * shoreLineCol.rgb ,shoreLineCol.rgb, _Lerp);

				fixed4 finalCol = fixed4(color, 0.8);
				    
				return finalCol ;
			}
		ENDCG
		}
  	}
}

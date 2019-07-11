Shader "AL/WorldWater"
{
	Properties{
        _ShallowColor ("ShallowColor", Color) = (0.5, 0.5, 1, 1)
		_DeepColor ("DeepColor", Color) = (0.8, 0.8, 1, 1)
		_RimColor ("RimColor", Color) = (1,1,1,1)
		_Control ("Control", 2D) = "white" {}
		_Normal ("Normal(World Normal)", 2D) = "white" {}
		_WaveSpeed ("Wave Speed", Range(0.0, 1.0)) = 0.2
		_Mix ("Mix", Range(0.001, 5.0)) = 1.0
		_SpecularRatio ("Specular Ratio", Range(1.0, 5.0)) = 3 
		_LightDir("LightDir (w:depth)", Vector)=(0,0,0,0)
        _LightColor("_LightColor", Color) = (1,1,1,1)
		[Enum(Palace, 0, Area1, 1, Area2, 2)] _Area("Area", Float) = 0
    }
    SubShader{
   
		Tags {
			"LightMode"="ForwardBase"
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
			#pragma target 2.0

			#include "UnityCG.cginc"

			struct a2v {
			    float4 vertex : POSITION;
			    float2 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 vertex : POSITION;				
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float4 time : TEXCOORD3;
			};

			sampler2D _Control;
			sampler2D _Normal;
			float4 _Control_ST;
			float4 _Normal_ST;
			float4 _Control_TexelSize;
			half4 _ShallowColor;
			half4 _DeepColor;
			half4 _RimColor;
			half4 _LightDir;
			half4 _LightColor;
			half _Mix;
			half _SpecularRatio;
			half _WaveSpeed;
			half _Area;

			v2f Vert(a2v v){
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.texcoord, _Control);
	        	o.uv1 = TRANSFORM_TEX(v.texcoord, _Normal);
				o.viewDir = UNITY_MATRIX_V[2].xyz;
				o.time = _Time;
				return o;
			}

			fixed4 frag (v2f i) : COLOR{

				fixed3 lightDir = -normalize(_LightDir.xyz);
				fixed3 viewDir = normalize(i.viewDir);
				fixed3 HalfDir = normalize(viewDir + lightDir);

				float2 speed = _WaveSpeed * float2(i.time.x, i.time.x + 0.42478);
				float2 uv1 = i.uv1 - speed;
				float3 worldNormal = normalize(tex2D(_Normal, float2(uv1.y, i.uv1.x)).xyz) * 0.5;
				worldNormal += normalize(tex2D(_Normal, float2(i.uv1.y, uv1.x)).xyz) * 0.5;

				float3 control = tex2D(_Control, i.uv0).rgb;
				float depth = lerp(control.r, lerp(control.g, control.b, saturate(_Area - 1.0)), saturate(_Area));

				fixed4 diffuse = lerp(_ShallowColor, _DeepColor, saturate(pow(depth * _LightDir.w, _Mix)));
				diffuse = lerp(diffuse, _RimColor, saturate((0.02 - depth) * 50));

				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * diffuse.rgb;
				//diffuse.rgb *= saturate(dot(worldNormal, lightDir)) * _LightColor.rgb;
				
				fixed3 specular = pow(saturate(dot(worldNormal, HalfDir)), _SpecularRatio);
				specular *= step(0, dot(worldNormal, float3(0, 1, 0))) * _LightColor.rgb;
				
				fixed4 finalCol = fixed4(diffuse.rgb + specular, diffuse.a);//fixed4(ambient + diffuse.rgb + specular, diffuse.a);
				return finalCol;
			}
		ENDCG
		}
  	}
}
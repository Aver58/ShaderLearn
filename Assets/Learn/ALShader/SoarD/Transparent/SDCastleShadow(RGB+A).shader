Shader "SoarD/Transparent/SDCastleShadow(RGB+A)" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_AlphaTex("Alpha Tex",2D) = "white" {}
	}

		SubShader{
			Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
			CGPROGRAM
			#pragma surface surf Lambert vertex:vert alpha:fade
			sampler2D _MainTex;
			sampler2D _AlphaTex;
			fixed4 _Color;
			struct Input {
				float2 uv_MainTex;
				float4 color;
			};

			void vert(inout appdata_full v, out Input o)
			{
				UNITY_INITIALIZE_OUTPUT(Input,o);
				o.color = v.color;
			}

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
				o.Albedo = c.rgb * IN.color.rgb * _Color.rgb;
				o.Alpha = _Color.a * IN.color.a * alpha;
			}
			ENDCG
	}
}

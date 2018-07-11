// 受灯光影响,带顶点颜色(rgba)
Shader "Custom/VertexColorDiffuse" {
    Properties {
    	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    }

//    SubShader {
//		Tags {
//			"Queue"="Transparent" 
//			"IgnoreProjector"="True" 
//			"RenderType"="Transparent" 
//			"PreviewType"="Plane"
//			"CanUseSpriteAtlas"="True"
//		}
//			
//		Pass {
//			ZWrite Off
//			Blend SrcAlpha OneMinusSrcAlpha
//
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//
//			#include "UnityCG.cginc"
//			#include "Lighting.cginc"
//
//			struct a2v {
//				float4 vertex : POSITION;
//				float2 uv : TEXCOORD0;
//				float3 normal : NORMAL;
//				fixed4 color : COLOR;
//			};
//
//			struct v2f {
//				float2 uv : TEXCOORD;
//				float3 normal : TEXCOORD2;
//				float4 vertex : SV_POSITION;
//				fixed4 color : COLOR;
//			};
//
//			sampler2D _MainTex;
//			float4 _MainTex_ST;
//
//			v2f vert (a2v v) {
//				v2f o;
//
//				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
//				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
//				o.color = v.color;
//				o.normal = v.normal;
//
//				return o;
//			}
//			
//			fixed4 frag (v2f i) : SV_Target {
//				fixed4 mainTexCol = tex2D(_MainTex, i.uv);
//				fixed4 albedo = mainTexCol * i.color;
//
//				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT * albedo.rgb;
//				float3 worldNormal = UnityObjectToWorldNormal(i.normal);
//				float3 lightDir = UnityWorldSpaceLightDir(i.vertex);
//				fixed3 diffuse = _LightColor0.rgb * albedo.rgb * saturate(dot(worldNormal, lightDir));
//
//				return fixed4(ambient + diffuse, mainTexCol.a * i.color.a);
//			}
//			ENDCG
//		}

    SubShader {
        Tags {"Queue"="Transparent+100" "IgnoreProjector"="True" "RenderType"="Transparent"}
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert alpha:fade

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
            float4 color;
        };

        void vert(inout appdata_full v, out Input o)  
        {  
            UNITY_INITIALIZE_OUTPUT(Input,o);

            o.color = v.color;
        } 

        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex).rgba;

            o.Albedo.rgb = c.rgb * IN.color.rgb;
            o.Alpha = c.a * IN.color.a;
        }
        ENDCG
    }

    Fallback "Legacy Shaders/Transparent/VertexLit"
}

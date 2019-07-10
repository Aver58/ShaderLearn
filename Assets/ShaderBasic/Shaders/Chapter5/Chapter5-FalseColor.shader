// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/False Color" {

	Properties {
		_showNormal ("Show Normal(0.5为分界，是否显示)", Range(0,1)) = 0.5
		_showTangent ("Show Tangent", Range(0,1)) = 0.5
		_showBinormal ("Show Binormal", Range(0,1)) = 0.5
		_showTexcoord0 ("Show Texcoord0", Range(0,1)) = 0.5
		_showTexcoord1 ("Show Texcoord1", Range(0,1)) = 0.5
	
		_showFractional1 ("Show Fractional1", Range(0,1)) = 0.5
		_showFractional2 ("Show Fractional2", Range(0,1)) = 0.5
		_showVertex ("Show Vertex", Range(0,1)) = 0.5
	}
	SubShader {
		Pass {
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 color : COLOR0;
			};
			
			half _showNormal;
			half _showTangent;
			half _showBinormal;
			half _showTexcoord0;
			half _showTexcoord1;
			//half _showTexcoord2;// 2-3组都是空的
			//half _showTexcoord3;
			half _showFractional1;
			half _showFractional2;
			half _showVertex;

			v2f vert(appdata_full v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				// Visualize normal
				if(_showNormal >=0.5)
				{
					o.color = fixed4(v.normal , 1.0);
				}
				
				// Visualize tangent
				if(_showTangent >=0.5)
				{
					o.color = fixed4(v.tangent.xyz * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				}
				
				// Visualize binormal
				if(_showBinormal >=0.5)
				{
					fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
					o.color = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				}
				
				// Visualize the first set texcoord
				if(_showTexcoord0 >=0.5)
				{
					o.color = fixed4(v.texcoord.xy, 0.0, 1.0);
				}

				// Visualize the second set texcoord
				if(_showTexcoord1 >=0.5)
				{
					o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);
				}

				// Visualize fractional part of the first set texcoord
				if(_showFractional1 >=0.5)
				{
					o.color = frac(v.texcoord);
					if (any(saturate(v.texcoord) - v.texcoord)) {
						o.color.b = 0.5;
					}
					o.color.a = 1.0;
				}

				// Visualize fractional part of the second set texcoord
				if(_showFractional2 >=0.5)
				{
					o.color = frac(v.texcoord);
					if (any(saturate(v.texcoord) - v.texcoord)) {
						o.color.b = 0.5;
					}
					o.color.a = 1.0;
				}

				// Visualize vertex color
				if(_showVertex >=0.5)
				{
					o.color = v.color;
				}

				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				return i.color;
			}
			
			ENDCG
		}
	}
}

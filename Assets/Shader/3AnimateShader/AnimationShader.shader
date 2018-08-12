Shader "Unlit/AnimationShader"
{
	Properties{
	_Color("Main Clolr",Color)=(1,1,1,1)
	_MainTex("MainTex",2D)="white"{}
	_HorizantalAmount("HorizantalAmount",Float)=4
	_VerticalAmount("VerticalAmount",Float)=4
	_Speed("Speed",Range(1,100))=30
}

SubShader{
	Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		//关键帧动画中使用的关键帧图像一般包含透明通道，因此当成半透明来处理
	Pass{
		Tags{"LightMode"="ForwardBase"}
		ZWrite Off
		Blend  SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "Lighting.cginc"

		fixed4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		float _HorizantalAmount;
		float _VerticalAmount;
		float _Speed;  

		struct a2v{
			float4 vertex:POSITION;
			float4 texcoord:TEXCOORD0;
		};
		struct v2f{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert(a2v v){
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);

			return o;
		}

		fixed4 frag(v2f i):SV_Target{
			float time=floor(_Time.y*_Speed);   //内置时间变量 _Time(t/20,t,2t,3t)
			float row=floor(time/_HorizantalAmount);
			float column=time-row*_VerticalAmount;  
			//根据播放的速度计算对应的序列帧行和列

			//纹理中包含许多关键帧图像，将采样坐标映射到每一个关键帧的坐标范围内
			//纹理中的采样方向与关键帧的播放顺序在Y方向是反的，因此Y坐标做减法
			half2 uv=float2(i.uv.x/_HorizantalAmount,i.uv.y/_VerticalAmount);			
			uv.x+=column/_HorizantalAmount;
			uv.y-=row/_VerticalAmount;

			fixed4 c=tex2D(_MainTex,uv);
			c.rgb*=_Color;

			return c;

		}
		ENDCG
	}
}
FallBack "Transparent/VertexLit"
}

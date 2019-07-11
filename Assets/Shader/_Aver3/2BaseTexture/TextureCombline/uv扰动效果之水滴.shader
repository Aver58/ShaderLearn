// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/任务15uv扰动效果之水滴" 
{ 
Properties 
{ 
_MainTex("Texture", 2D) = "white" {} 
_UA("UA",Float) = 0.5 
_UB("UB",Float) = 0.5 
_RA("RA",Float) = 1 
_Speed("速度",Float) = 2 
_Scale("缩放",Float) = 10 
} 
SubShader 
{ 
Tags { "RenderType"="Opaque" } 
LOD 100 


Pass 
{ 
CGPROGRAM 
#pragma vertex vert 
#pragma fragment frag 
#include "UnityCG.cginc" 


sampler2D _MainTex; float4 _MainTex_ST; 
float _UA; 
float _UB; 
float _RA; 
float _Speed; 
float _Scale; 


struct v2f 
{ 
float2 uv : TEXCOORD0; 
float4 pos : SV_POSITION; 
}; 

v2f vert (appdata_full v) 
{ 
v2f o; 
o.pos = UnityObjectToClipPos(v.vertex); 
o.uv = v.texcoord; 
return o; 
} 

fixed4 frag (v2f i) : SV_Target 
{ 
    float2 di = float2(_UA,_UB); 
    float dis = distance(di,i.uv); 
float angle = asin((di.y - i.uv.y)/dis); 
float z = (abs(sin(log(saturate(dis))*dis * _Scale+ _Time.y * _Speed)))/80; 
fixed4 col; 
col = tex2D(_MainTex,i.uv + float2(z,z)); 
return col; 
} 
ENDCG 
} 
} 
} 
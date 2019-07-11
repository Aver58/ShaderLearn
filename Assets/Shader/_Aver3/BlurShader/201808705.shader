// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:697,x:33471,y:32709,varname:node_697,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:3336,x:33020,y:32720,ptovrint:False,ptlb:mainTexture,ptin:_mainTexture,varname:node_3336,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:5336,x:32881,y:32918,ptovrint:False,ptlb:blur_radius,ptin:_blur_radius,varname:node_5336,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:15;n:type:ShaderForge.SFN_Slider,id:9364,x:32842,y:33110,ptovrint:False,ptlb:texture_size,ptin:_texture_size,varname:node_9364,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:256,max:512;n:type:ShaderForge.SFN_Divide,id:6972,x:33169,y:33029,varname:node_6972,prsc:2|A-3827-OUT,B-9364-OUT;n:type:ShaderForge.SFN_Vector1,id:3827,x:32977,y:32992,varname:node_3827,prsc:2,v1:1;proporder:3336-5336;pass:END;sub:END;*/

Shader "Hidden/7.5" {
    Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TextureSize ("_TextureSize",Float) = 256
        _BlurRadius ("_BlurRadius",Range(1,15) ) = 5
    }
    SubShader {
        Tags {"RenderType"="Opaque"}
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0

			sampler2D _MainTex;
			int _BlurRadius;
			float _TextureSize;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert( appdata_img v ) 
			{
			    v2f o;
			    o.pos = UnityObjectToClipPos(v.vertex);
			    o.uv = v.texcoord.xy;
			    return o;
			} 

			//得到模糊的颜色
			float4 GetBlurColor( float2 uv )
			{
			
			    float space = 1.0/_TextureSize; //算出一个像素的空间
			    int count = _BlurRadius * 2 +1; //取值范围
			    count *= count;
			
			    //将以自己为中心，周围半径的所有颜色相加，然后除以总数，求得平均值
			    float4 colorTmp = float4(0,0,0,0);
			    for( int x = -_BlurRadius ; x <= _BlurRadius ; x++ )
			    {
			        for( int y = -_BlurRadius ; y <= _BlurRadius ; y++ )
			        {
			            float4 color = tex2D(_MainTex,uv + float2(x * space,y * space));
			            colorTmp += color;
			        }
			    }
			    return colorTmp/count;
			}
			half4 frag(v2f i) : SV_Target 
			{
			    //调用普通模糊
			    return GetBlurColor(i.uv);
			    //调用高斯模糊  
			    //return GetGaussBlurColor(i.uv);
			    //return tex2D(_MainTex,i.uv);
			}

            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

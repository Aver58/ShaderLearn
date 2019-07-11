// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9361,x:33209,y:32712,varname:node_9361,prsc:2|custl-6743-OUT;n:type:ShaderForge.SFN_ScreenPos,id:8439,x:31785,y:32726,varname:node_8439,prsc:2,sctp:0;n:type:ShaderForge.SFN_Slider,id:4918,x:31660,y:32929,ptovrint:False,ptlb:offsetX,ptin:_offsetX,varname:_offsetX,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5147217,max:1;n:type:ShaderForge.SFN_Add,id:7769,x:32673,y:32874,varname:node_7769,prsc:2|A-3978-RGB,B-3717-RGB,C-6802-RGB;n:type:ShaderForge.SFN_SceneColor,id:3717,x:32379,y:32816,varname:node_3717,prsc:2|UVIN-4081-OUT;n:type:ShaderForge.SFN_Append,id:4081,x:32213,y:32814,varname:node_4081,prsc:2|A-8439-V,B-4918-OUT;n:type:ShaderForge.SFN_Append,id:6502,x:32219,y:33032,varname:node_6502,prsc:2|A-8439-U,B-4918-OUT;n:type:ShaderForge.SFN_SceneColor,id:6802,x:32389,y:33035,varname:node_6802,prsc:2|UVIN-6502-OUT;n:type:ShaderForge.SFN_Divide,id:6743,x:32863,y:32880,varname:node_6743,prsc:2|A-7769-OUT,B-3603-OUT;n:type:ShaderForge.SFN_Vector1,id:3603,x:32654,y:33074,varname:node_3603,prsc:2,v1:2;n:type:ShaderForge.SFN_SceneColor,id:3978,x:32387,y:32637,varname:node_3978,prsc:2|UVIN-8439-UVOUT;n:type:ShaderForge.SFN_Add,id:8978,x:32049,y:33028,varname:node_8978,prsc:2|A-8439-V,B-4918-OUT;n:type:ShaderForge.SFN_Add,id:6376,x:32040,y:32814,varname:node_6376,prsc:2|A-8439-U,B-4918-OUT;proporder:4918;pass:END;sub:END;*/

Shader "Shader Forge/BlurShader" {
    Properties {
        _offsetX ("offsetX", Range(0, 1)) = 0.5147217
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _offsetX;
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float3 finalColor = ((tex2D( _GrabTexture, i.screenPos.rg).rgb+tex2D( _GrabTexture, float2(i.screenPos.g,_offsetX)).rgb+tex2D( _GrabTexture, float2(i.screenPos.r,_offsetX)).rgb)/2.0);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

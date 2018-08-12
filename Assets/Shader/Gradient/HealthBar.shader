// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:5656,x:32797,y:32725,varname:node_5656,prsc:2|emission-5546-OUT,clip-4110-OUT;n:type:ShaderForge.SFN_Lerp,id:5546,x:32217,y:32774,varname:node_5546,prsc:2|A-7381-RGB,B-2836-RGB,T-7730-OUT;n:type:ShaderForge.SFN_Color,id:2836,x:31617,y:32728,ptovrint:False,ptlb:colorA,ptin:_colorA,varname:node_2836,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Color,id:7381,x:31602,y:32510,ptovrint:False,ptlb:colorB,ptin:_colorB,varname:_colorA_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:1,c3:0,c4:1;n:type:ShaderForge.SFN_Floor,id:5612,x:31770,y:33465,varname:node_5612,prsc:2|IN-9055-OUT;n:type:ShaderForge.SFN_TexCoord,id:6105,x:30868,y:33157,varname:node_6105,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_RemapRange,id:582,x:31055,y:33157,varname:node_582,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-6105-UVOUT;n:type:ShaderForge.SFN_Length,id:9055,x:31562,y:33445,varname:node_9055,prsc:2|IN-582-OUT;n:type:ShaderForge.SFN_OneMinus,id:3962,x:32012,y:33408,varname:node_3962,prsc:2|IN-5612-OUT;n:type:ShaderForge.SFN_Slider,id:7730,x:31492,y:32953,ptovrint:False,ptlb:lerp_ctrl,ptin:_lerp_ctrl,varname:node_7730,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Add,id:1913,x:31754,y:33302,varname:node_1913,prsc:2|A-1481-OUT,B-9055-OUT;n:type:ShaderForge.SFN_Vector1,id:1481,x:31596,y:33264,varname:node_1481,prsc:2,v1:0.3;n:type:ShaderForge.SFN_Floor,id:8284,x:32016,y:33275,varname:node_8284,prsc:2|IN-1913-OUT;n:type:ShaderForge.SFN_Multiply,id:4110,x:32345,y:33174,varname:node_4110,prsc:2|A-8919-OUT,B-8284-OUT,C-3962-OUT;n:type:ShaderForge.SFN_ComponentMask,id:7915,x:31303,y:33109,varname:node_7915,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-582-OUT;n:type:ShaderForge.SFN_ArcTan2,id:8110,x:31615,y:33099,varname:node_8110,prsc:2,attp:2|A-7915-G,B-7915-R;n:type:ShaderForge.SFN_Subtract,id:2221,x:31842,y:33050,varname:node_2221,prsc:2|A-7730-OUT,B-8110-OUT;n:type:ShaderForge.SFN_Ceil,id:354,x:32015,y:33050,varname:node_354,prsc:2|IN-2221-OUT;n:type:ShaderForge.SFN_OneMinus,id:8919,x:32177,y:33087,varname:node_8919,prsc:2|IN-354-OUT;proporder:2836-7381-7730;pass:END;sub:END;*/

Shader "Hidden/Wave" {
    Properties {
        _colorA ("colorA", Color) = (1,0,0,1)
        _colorB ("colorB", Color) = (0,1,0,1)
        _lerp_ctrl ("lerp_ctrl", Range(0, 1)) = 1
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
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
            uniform float4 _colorA;
            uniform float4 _colorB;
            uniform float _lerp_ctrl;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float2 node_582 = (i.uv0*2.0+-1.0);
                float2 node_7915 = node_582.rg;
                float node_9055 = length(node_582);
                clip(((1.0 - ceil((_lerp_ctrl-((atan2(node_7915.g,node_7915.r)/6.28318530718)+0.5))))*floor((0.3+node_9055))*(1.0 - floor(node_9055))) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = lerp(_colorB.rgb,_colorA.rgb,_lerp_ctrl);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _lerp_ctrl;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float2 node_582 = (i.uv0*2.0+-1.0);
                float2 node_7915 = node_582.rg;
                float node_9055 = length(node_582);
                clip(((1.0 - ceil((_lerp_ctrl-((atan2(node_7915.g,node_7915.r)/6.28318530718)+0.5))))*floor((0.3+node_9055))*(1.0 - floor(node_9055))) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

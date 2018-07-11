// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:5656,x:32726,y:32723,varname:node_5656,prsc:2|emission-5546-OUT,voffset-3553-OUT;n:type:ShaderForge.SFN_Lerp,id:5546,x:32443,y:32801,varname:node_5546,prsc:2|A-2836-RGB,B-7381-RGB,T-7012-OUT;n:type:ShaderForge.SFN_Color,id:2836,x:32165,y:32639,ptovrint:False,ptlb:colorA,ptin:_colorA,varname:node_2836,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.006896496,c3:0.884,c4:1;n:type:ShaderForge.SFN_Color,id:7381,x:32166,y:32819,ptovrint:False,ptlb:colorB,ptin:_colorB,varname:_colorA_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.8947964,c3:1,c4:1;n:type:ShaderForge.SFN_TexCoord,id:3458,x:30994,y:32900,varname:node_3458,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_RemapRange,id:4051,x:31977,y:32973,varname:node_4051,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-2124-OUT;n:type:ShaderForge.SFN_Sin,id:2124,x:31780,y:32972,varname:node_2124,prsc:2|IN-7148-OUT;n:type:ShaderForge.SFN_ComponentMask,id:2602,x:31192,y:32909,varname:node_2602,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-3458-UVOUT;n:type:ShaderForge.SFN_Multiply,id:7148,x:31579,y:32970,varname:node_7148,prsc:2|A-8816-OUT,B-3461-OUT,C-6092-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3461,x:31366,y:33052,ptovrint:False,ptlb:Strength,ptin:_Strength,varname:node_3461,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:4;n:type:ShaderForge.SFN_Tau,id:6092,x:31395,y:33118,varname:node_6092,prsc:2;n:type:ShaderForge.SFN_Clamp01,id:7012,x:32161,y:32974,varname:node_7012,prsc:2|IN-4051-OUT;n:type:ShaderForge.SFN_Add,id:8816,x:31366,y:32908,varname:node_8816,prsc:2|A-2602-OUT,B-6076-TSL;n:type:ShaderForge.SFN_Time,id:6076,x:31193,y:33054,varname:node_6076,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:3567,x:32163,y:33108,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:3553,x:32367,y:33171,varname:node_3553,prsc:2|A-7012-OUT,B-3567-OUT,C-2608-OUT;n:type:ShaderForge.SFN_Vector1,id:2608,x:32166,y:33272,cmnt:offset,varname:node_2608,prsc:2,v1:2;n:type:ShaderForge.SFN_FragmentPosition,id:5949,x:31002,y:32758,varname:node_5949,prsc:2;proporder:2836-7381-3461;pass:END;sub:END;*/

Shader "Hidden/Wave" {
    Properties {
        _colorA ("colorA", Color) = (0,0.006896496,0.884,1)
        _colorB ("colorB", Color) = (0,0.8947964,1,1)
        _Strength ("Strength", Float ) = 4
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
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
            uniform float4 _TimeEditor;
            uniform float4 _colorA;
            uniform float4 _colorB;
            uniform float _Strength;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_6076 = _Time + _TimeEditor;
                float node_7012 = saturate((sin(((o.uv0.r+node_6076.r)*_Strength*6.28318530718))*0.5+0.5));
                v.vertex.xyz += (node_7012*v.normal*2.0);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_6076 = _Time + _TimeEditor;
                float node_7012 = saturate((sin(((i.uv0.r+node_6076.r)*_Strength*6.28318530718))*0.5+0.5));
                float3 emissive = lerp(_colorA.rgb,_colorB.rgb,node_7012);
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
            uniform float4 _TimeEditor;
            uniform float _Strength;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_6076 = _Time + _TimeEditor;
                float node_7012 = saturate((sin(((o.uv0.r+node_6076.r)*_Strength*6.28318530718))*0.5+0.5));
                v.vertex.xyz += (node_7012*v.normal*2.0);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

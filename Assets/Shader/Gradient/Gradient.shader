// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:8575,x:32719,y:32712,varname:node_8575,prsc:2|emission-1276-OUT;n:type:ShaderForge.SFN_TexCoord,id:8903,x:31282,y:33074,varname:node_8903,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Lerp,id:1276,x:32493,y:32814,varname:node_1276,prsc:2|A-4781-RGB,B-9502-RGB,T-1986-OUT;n:type:ShaderForge.SFN_Color,id:4781,x:32122,y:32602,ptovrint:False,ptlb:color1,ptin:_color1,varname:node_4781,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Color,id:9502,x:32126,y:32781,ptovrint:False,ptlb:color2,ptin:_color2,varname:_node_4781_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.03448248,c2:0,c3:1,c4:1;n:type:ShaderForge.SFN_RemapRange,id:7177,x:31765,y:32938,varname:node_7177,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-8903-UVOUT;n:type:ShaderForge.SFN_Length,id:9015,x:32266,y:32988,varname:node_9015,prsc:2|IN-7177-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1194,x:32060,y:33140,varname:node_1194,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-7177-OUT;n:type:ShaderForge.SFN_ArcTan2,id:1986,x:32258,y:33157,varname:node_1986,prsc:2,attp:3|A-1194-G,B-1194-R;proporder:4781-9502;pass:END;sub:END;*/

Shader "Hidden/Gradient" {
    Properties {
        _color1 ("color1", Color) = (1,0,0,1)
        _color2 ("color2", Color) = (0,0,1,1)
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
            uniform float4 _color1;
            uniform float4 _color2;
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
////// Lighting:
////// Emissive:
                float2 node_7177 = (i.uv0*2.0+-1.0);
                float2 node_1194 = node_7177.rg;
                float3 emissive = lerp(_color1.rgb,_color2.rgb,(1-abs(atan2(node_1194.g,node_1194.r)/3.14159265359)));
                float3 finalColor = emissive;
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

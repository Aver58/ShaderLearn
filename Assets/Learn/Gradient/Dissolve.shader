// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9753,x:33109,y:32755,varname:node_9753,prsc:2|diff-8186-RGB,emission-6554-RGB,clip-8086-OUT;n:type:ShaderForge.SFN_Tex2d,id:8186,x:32804,y:32549,ptovrint:False,ptlb:base_Texture,ptin:_base_Texture,varname:_base_Texture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6e3881ca7d780b34aa9969c5ad6c0197,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:6295,x:31446,y:33272,ptovrint:False,ptlb:Noise_Texture,ptin:_Noise_Texture,varname:_Noise_Texture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5d9bfca0fb4befd49aec355d211528e8,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:5209,x:32631,y:32939,ptovrint:False,ptlb:Dissolve_percent,ptin:_Dissolve_percent,varname:_Dissolve_percent,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:8102,x:31447,y:33040,varname:node_8102,prsc:2,frmn:0,frmx:1,tomn:-0.2,tomx:0.4|IN-1863-OUT;n:type:ShaderForge.SFN_Add,id:8086,x:31662,y:33021,varname:node_8086,prsc:2|A-8102-OUT,B-6295-G;n:type:ShaderForge.SFN_OneMinus,id:1863,x:31258,y:33043,varname:node_1863,prsc:2|IN-5209-OUT;n:type:ShaderForge.SFN_Clamp01,id:1083,x:31967,y:33080,varname:node_1083,prsc:2|IN-8086-OUT;n:type:ShaderForge.SFN_Append,id:5452,x:32436,y:33143,varname:node_5452,prsc:2|A-5786-OUT,B-5786-OUT;n:type:ShaderForge.SFN_OneMinus,id:5786,x:32220,y:33075,varname:node_5786,prsc:2|IN-1083-OUT;n:type:ShaderForge.SFN_Tex2d,id:6554,x:32614,y:33143,varname:_node_7834_copy,prsc:2,tex:e6e7abfd01541984db62a8d677d6b2d7,ntxv:0,isnm:False|UVIN-5452-OUT,TEX-4900-TEX;n:type:ShaderForge.SFN_Tex2dAsset,id:4900,x:32233,y:33421,ptovrint:False,ptlb:Add_Texture,ptin:_Add_Texture,varname:_Add_Texture,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e6e7abfd01541984db62a8d677d6b2d7,ntxv:0,isnm:False;proporder:6295-5209-8186-4900;pass:END;sub:END;*/

Shader "Hidden/ColorRamp" {
    Properties {
        _Noise_Texture ("Noise_Texture", 2D) = "white" {}
        _Dissolve_percent ("Dissolve_percent", Range(0, 1)) = 0
        _base_Texture ("base_Texture", 2D) = "white" {}
        _Add_Texture ("Add_Texture", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _base_Texture; uniform float4 _base_Texture_ST;
            uniform sampler2D _Noise_Texture; uniform float4 _Noise_Texture_ST;
            uniform float _Dissolve_percent;
            uniform sampler2D _Add_Texture; uniform float4 _Add_Texture_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float4 _Noise_Texture_var = tex2D(_Noise_Texture,TRANSFORM_TEX(i.uv0, _Noise_Texture));
                float node_8086 = (((1.0 - _Dissolve_percent)*0.6+-0.2)+_Noise_Texture_var.g);
                clip(node_8086 - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _base_Texture_var = tex2D(_base_Texture,TRANSFORM_TEX(i.uv0, _base_Texture));
                float3 diffuseColor = _base_Texture_var.rgb;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float node_5786 = (1.0 - saturate(node_8086));
                float2 node_5452 = float2(node_5786,node_5786);
                float4 _node_7834_copy = tex2D(_Add_Texture,TRANSFORM_TEX(node_5452, _Add_Texture));
                float3 emissive = _node_7834_copy.rgb;
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _base_Texture; uniform float4 _base_Texture_ST;
            uniform sampler2D _Noise_Texture; uniform float4 _Noise_Texture_ST;
            uniform float _Dissolve_percent;
            uniform sampler2D _Add_Texture; uniform float4 _Add_Texture_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float4 _Noise_Texture_var = tex2D(_Noise_Texture,TRANSFORM_TEX(i.uv0, _Noise_Texture));
                float node_8086 = (((1.0 - _Dissolve_percent)*0.6+-0.2)+_Noise_Texture_var.g);
                clip(node_8086 - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _base_Texture_var = tex2D(_base_Texture,TRANSFORM_TEX(i.uv0, _base_Texture));
                float3 diffuseColor = _base_Texture_var.rgb;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
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
            uniform sampler2D _Noise_Texture; uniform float4 _Noise_Texture_ST;
            uniform float _Dissolve_percent;
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
                float4 _Noise_Texture_var = tex2D(_Noise_Texture,TRANSFORM_TEX(i.uv0, _Noise_Texture));
                float node_8086 = (((1.0 - _Dissolve_percent)*0.6+-0.2)+_Noise_Texture_var.g);
                clip(node_8086 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

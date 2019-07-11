Shader "Lee/Shader_currency" {
    Properties {
        [Header(Model)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1
		[Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0

		[KeywordEnum(Off,On)]_Dissolve_MainNoise("Dissolve_MainNoise",Float) = 0

        _Color ("Color", Color) = (1,1,1,1)
       
        _VertexColor_L ("VertexColor_L", Float ) = 1
        _VertexColor_A ("VertexColor_A", Float ) = 1
        _MainTex ("MainTex", 2D) = "white" {}
        _Tex_U ("Tex_U", Float ) = 0
        _Tex_V ("Tex_V", Float ) = 0
        _MainOpa ("MainOpa", 2D) = "white" {}
        _Opa_U("Opa_U", Float ) = 0
        _Opa_V("Opa_V", Float ) = 0
        _MainNoise ("MainNoise", 2D) = "white" {}
        _Noise_Value ("Noise_Value", Float ) = 0
        _Noise01_V ("Noise01_V", Float ) = 0
        _Noise01_U ("Noise01_U", Float ) = 0

        _Noise02_V ("Noise02_V", Float ) = 0
        _Noise02_U ("Noise02_U", Float ) = 0

        [MaterialToggle] _MainTex_T ("MainTex_T", Float ) = 1
        [MaterialToggle] _Main_A ("Main_A", Float ) = 1
        [MaterialToggle] _Main_R ("Main_R", Float ) = 0
        [MaterialToggle] _Main_G ("Main_G", Float ) = 0
        [MaterialToggle] _Main_B ("Main_B", Float ) = 0
        [MaterialToggle] _Main_O ("Main_O", Float ) = 0
        [MaterialToggle] _UseBlur ("UseBlur", Float ) = 0
         _dissolve("Dissolve",range(0,2)) = -1
        _blur("Blur", Range(0,1)) = 1

        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags 
        {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
        }
        Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
			Cull [_Cull]
			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			ZTest [_ZTest]

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 2.0
            #pragma multi_compile _DISSOLVE_MAINNOISE_OFF _DISSOLVE_MAINNOISE_ON 

       
            uniform sampler2D _MainOpa; uniform fixed4 _MainOpa_ST;
            uniform sampler2D _MainTex; uniform fixed4 _MainTex_ST;
            uniform fixed4 _Color;
            uniform fixed _MainTex_T;
            uniform fixed _Main_A;
            uniform float _Tex_U;
            uniform float _Tex_V;
            uniform sampler2D _MainNoise; uniform float4 _MainNoise_ST;
            uniform float _Noise01_V;
            uniform float _Noise01_U;
            uniform float _Noise02_V;
            uniform float _Noise02_U;
            uniform float _Noise_Value;
            uniform fixed _Main_R;
            uniform fixed _Main_G;
            uniform fixed _Main_B;
            uniform fixed _Main_O;
            uniform fixed _Opa_U;
            uniform fixed _Opa_V;

            uniform fixed _blur;
            uniform fixed _UseBlur;


            fixed _VertexColor_A;
            fixed _VertexColor_L;

            uniform fixed _dissolve;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 time : TEXCOORD1;
                float4 vertexColor : COLOR;               
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o ;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                o.time = _Time;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
            #if _DISSOLVE_MAINNOISE_ON   
                fixed2 m_MainNoiseUV_01 = (i.uv0+(float2(_Noise01_U,_Noise01_V)*i.time.g));
                float4 m_MainNoiseA = tex2D(_MainNoise,TRANSFORM_TEX(m_MainNoiseUV_01, _MainNoise));
                       
                fixed2 m_MainNoiseUV_02 = (i.uv0+(float2(_Noise02_U,_Noise02_V)*i.time.g));
                float4 m_MainNoiseB = tex2D(_MainNoise,TRANSFORM_TEX(m_MainNoiseUV_02, _MainNoise));   

                float4 m_MainNoise = m_MainNoiseA.r *  m_MainNoiseB.r;
            #else
            	float4 m_MainNoise = float4(1,1,1,1);
           		float _Noise_Value = 0;
            #endif
                float3 _COLORRGBA = (_Color.rgb*_Color.a);     

                float2 _MainOpaVarUV =i.uv0 + float2(_Opa_U ,_Opa_V) * i.time.r;       
                float4 _MainOpaVar = tex2D(_MainOpa,TRANSFORM_TEX(_MainOpaVarUV, _MainOpa));

                float2 _MainTexUV = ((i.uv0+(float2(_Tex_U,_Tex_V)*i.time.g))+(m_MainNoise.r*_Noise_Value ));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_MainTexUV, _MainTex));

                float3 finalColor = ((_COLORRGBA*lerp( _COLORRGBA, _MainTex_var.rgb, _MainTex_T ))*(_VertexColor_L*i.vertexColor.rgb));    

                float VC = (i.vertexColor.a - 0.5)*-2;
                fixed4 finalRGBA = fixed4(finalColor,(lerp(i.vertexColor.a* _VertexColor_A,smoothstep( VC + _dissolve,VC + _dissolve + _blur,_MainOpaVar.g),_UseBlur)*(lerp( 0, 1.0, _Main_A )+lerp( 0, _MainTex_var.r, _Main_R )+lerp( 0, _MainTex_var.g, _Main_G )+lerp( 0, _MainTex_var.b * _MainOpaVar.r , _Main_B )+lerp( 0, _MainOpaVar.r, _Main_O ))));
            
                return finalRGBA;
            }
            ENDCG
        }
    }
 }

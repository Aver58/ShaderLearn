Shader "Unlit/TestUsePass" 
{ 
        Properties 
        { 
                _MainTex ("Texture", 2D) = "white" {} 
        } 
        SubShader 
        { 
                Tags { "RenderType"="Opaque" } 
                LOD 100 
				//必须使用大写形式的名字。
                UsePass "Unlit/WorldSpaceNormals/MYPASS" 
        } 
} 

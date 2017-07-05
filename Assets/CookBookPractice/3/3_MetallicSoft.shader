//@wildWind 金属软高光
Shader "MyCkBook/3_MetallicSoft"
{
	Properties
	{
		_MainTexture("MainTexture",2D) = "white"{}
		_MainTint("MainTint",Color) = (1,1,1,1)
		_RoughnessTex("Roughness Texture") = ""{}
		_Roughness("Roughness",Range(0,1)) = 0.5
		_SpecularColor ("Specular Color",Color) = (1,1,1,1)
		_SpecPower("SpecPower",Range(0,30)) = 2
		_Fresnel("Fresnel Value",Range(0,1.0)) = 0.05 //   菲涅尔准则
	}


	SubShader
	{
		
	
	
	}

	FallBack "Diffuse"
}
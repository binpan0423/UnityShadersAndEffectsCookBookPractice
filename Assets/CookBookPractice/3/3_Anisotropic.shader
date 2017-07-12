Shader "MyCkBook/3_Anisotropic" 
{
	Properties
	{
		_MainTex("_MainTex",2D) = "white" {}
		_MainTint("_MainTint",Color) = (1,1,1,1)
		_SpecularColor("_Specular",Color) = (1,1,1,1)
		_Specular("_SpecularAmount",Range(0,1)) = 0.5 // * 
		_SpecularPow("_SpecularPow",Range(0,1)) = 0.5 //Gloss  pow
		_AnisotropicTex("AnisoDir",2D) = ""{}
		_AnisotropicOffest("AnisoOffset",Range(-1,1)) = -0.2
	}
	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		CGPROGRAM

		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _Specular;
		float _SpecularPow;
		sampler2D _AnisotropicTex;
		float _AnisotropicOffest;
	
		struct SurfaceOutputCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection; //
			fixed  Gloss;
			fixed  Alpha;
			half Specular;
		};

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_AnisotropicTex;
		};

		void surf(Input IN,inout SurfaceOutputCustom o)
		{
			half4 c = tex2D(_MainTex,IN.uv_MainTex)*_MainTint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisotropicTex,IN.uv_AnisotropicTex));

			o.AnisoDirection = anisoTex;
			o.Albedo = c.rgb;
			o.Alpha  = c.a;
			o.Specular = _Specular;
			o.Gloss = _SpecularPow;
		}

		inline fixed4 LightingAnisotropic(SurfaceOutputCustom s,fixed3 lightDir,half3 viewDir,half atten)
		{
			fixed3 halfVector = normalize(lightDir + viewDir);
			float NdotL = saturate(dot(s.Normal,lightDir));

			fixed HdotA = dot(normalize(s.Normal + s.AnisoDirection),halfVector);
			float aniso = max(0,sin(radians((HdotA + _AnisotropicOffest) * 180)));

			float spec = saturate(pow(aniso,s.Gloss * 128) *s.Specular);  //  放大效果  并且在全局上降低强度

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec)*(atten*2);
			c.a = s.Alpha;
			return c;
		}




		ENDCG
	
	}
	
	FallBack "Diffuse"
}

//@wildWind 金属的软高光效果   类似CookTorrance
Shader "MyCkBook/3_MetallicSoft"
{
	Properties
	{
		_MainTexture("MainTexture",2D) = "white"{}
		_MainTint("MainTint",Color) = (1,1,1,1)
		_RoughnessTex("Roughness Texture",2D) = ""{}
		_Roughness("Roughness",Range(0,1)) = 0.5
		_SpecularColor ("Specular Color",Color) = (1,1,1,1)
		_SpecPower("SpecPower",Range(0,30)) = 2
		_Fresnel("Fresnel Value",Range(0,1.0)) = 0.05 //   菲涅尔准则
	}


	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf MetallicSoft
		#pragma target 3.0

		sampler2D _MainTexture;
		float4 _MainTint;
		sampler2D _RoughnessTex;
		float _Roughness;
		float4 _SpecularColor;
		float _SpecPower;
		float _Fresnel;



		struct Input
		{
			float2 uv_MainTexture;
		};
	    void surf(Input IN,inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTexture,IN.uv_MainTexture) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		inline fixed4 LightingMetallicSoft(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			
			float nDotL = saturate(dot(s.Normal,lightDir));
			
			float3 halfVector = normalize(lightDir + viewDir);
			float nDotH_raw = dot(s.Normal,halfVector);
			float nDotH = saturate(nDotH_raw);

			float nDotV = saturate(dot(s.Normal,viewDir));

			float vDotH = saturate(dot(viewDir,halfVector));

			//micro facets distribution 微面源分布 这边书上的公式是错误的 正确的https://en.wikipedia.org/wiki/Specular_highlight#Cook.E2.80.93Torrance_model
			float geoEnum = 2.0 * nDotH;
			float3 G1 = (geoEnum * nDotV)/vDotH;
			float3 G2 = (geoEnum * nDotL)/vDotH;
			float3 G = min(1.0f,min(G1,G2));
			

			//?
			float roughNess = tex2D(_RoughnessTex,float2(nDotH_raw * 0.5 + 0.5,_Roughness)).r;



			//对fresnel 反射的近似公式 https://en.wikipedia.org/wiki/Schlick%27s_approximation
			float fresnel = pow(1.0-vDotH,5.0); //和中间向量夹角越小，fresne 越小
			fresnel *= (1.0-_Fresnel);
			fresnel += _Fresnel;

			//spec  依据fresnel 和 G 以及RoughNess决定
			float3 spec = float3(fresnel * G *roughNess * roughNess) * _SpecPower;


			fixed4 c;
			c.a = s.Alpha;
			c.rgb = (s.Albedo * _LightColor0.rgb * nDotL) + (spec * _SpecularColor.rgb)*(atten*2);
			return c;
		}
		ENDCG
	}

	FallBack "Diffuse"
} 
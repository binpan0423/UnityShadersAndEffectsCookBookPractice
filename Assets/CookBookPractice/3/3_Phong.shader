//@wildWind Phong
Shader "MyCkBook/3_Phong"
{
	Properties
	{
		_MainTexture("Main Texture",2D) = "white"{}
		_MainTint("Main Tint",Color) = (1,1,1,1)
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecPow("Specular Pow",Range(0.1,30)) = 1.0
		_SpecHardness("Specular Hardness",Range(0.1,10)) = 2
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Phong

		sampler2D _MainTexture;
		fixed4 _MainTint;
		fixed4 _SpecularColor;
		float _SpecPow;
		float _SpecHardness;

		struct Input
		{
			fixed2 uv_MainTexture;
		};

		void surf(Input IN,inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTexture,IN.uv_MainTexture) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}


		inline fixed4 LightingPhong(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			//漫反射强度
			float diff = dot(s.Normal,lightDir);
			//计算反射光线的方向
			float3 reflectDir = normalize(-lightDir + 2*s.Normal*diff);

			float spec = pow(max(0,dot(reflectDir,viewDir)),_SpecPow);
			float3 finalSpec = _SpecularColor.rgb * spec;

			//final color
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff ) + (_LightColor0.rgb * finalSpec);
			c.a = 1;
			return c;
		}

		

		ENDCG
	}

	FallBack "Diffuse"
}
//@wildWind Phong
Shader "MyCkBook/3_BlinnPhong"
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
		#pragma surface surf CustomBlinnPhong

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


		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			//漫反射强度
			float diff = dot(s.Normal,lightDir);
			//计算光照方向和观察方向的中间向量
			float3 halfDir = normalize(lightDir + viewDir);

			float spec = pow(max(0,dot(halfDir,s.Normal)),_SpecPow);
			float3 finalSpec = _SpecularColor.rgb * spec;

			//final color
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff ) + (_LightColor0.rgb * finalSpec) * atten * 2 ; //这边atten * 2 主要是历史遗留因素
			c.a = 1;
			return c;
		}

		

		ENDCG
	}

	FallBack "Diffuse"
}

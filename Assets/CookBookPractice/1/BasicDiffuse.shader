Shader "MyCkBook/BasicDiffuse"
{
	Properties
	{
		//_MainTex("Base(RGB)",2D)  = "White"{}
		_EmissiveColor("EmissiveColor",Color) = (1,1,1,1)
		_AmbientColor("AmbientColor",Color) = (1,1,1,1)
		_MySliderValue("Slider",Range(0,10)) = 2.5
		_RampTex("rampText",2D) = "White"{}
	}
	
	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		
		CGPROGRAM
		//#pragma surface surf Lambert
		#pragma surface surf BasicDiffuse //Use Own light Model
		
		//sampler2D _MainTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float  _MySliderValue;
		sampler2D _RampTex;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			//half4 c = tex2D(_MainTex,IN.uv_MainTex);
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor),_MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;					
		}
		
		// inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,fixed atten)
		// {
			// float difLight = max(0,dot(s.Normal,lightDir));
			// difLight = difLight * 0.5 + 0.5;  //half lambert 
			
			// float3 ramp  = tex2D(_RampTex,float2(difLight,difLight)).rgb;
			
			// fixed4 color;
			// color.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			// color.a = s.Alpha;
			// return color;
		// }
		
		
		inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
		{
			float difLight = max(0,dot(s.Normal,lightDir));
			float rimLight = dot(s.Normal,viewDir);
			float halfLambert = difLight * 0.5 + 0.5;  //half lambert 
			float3 ramp  = tex2D(_RampTex,float2(halfLambert,rimLight)).rgb;
			fixed4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			color.a = s.Alpha;
			return color;
			
		}
		
		
		ENDCG
	}
	
	FallBack"Diffuse"
}
Shader "MyCkBook/2_NormalMapping"
{
	Properties
	{
		_MainTint("MainTint",Color) = (1,1,1,1)
		_NormalMap("Normal Map",2D) = "bump"{}
		_NormalMapIntensity("NormalMap Intensity",Range(0,2)) = 1.0
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		sampler2D _NormalMap;
		float _NormalMapIntensity;
		fixed4 _MainTint;
		
		struct Input
		{
			float2 uv_NormalMap;
		};
		
		void surf(Input IN,inout SurfaceOutput o)
		{
			float3 normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
			normal = float3(normal.x * _NormalMapIntensity,normal.y * _NormalMapIntensity,
			normal.z);
			o.Normal = normal.rgb;
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		
		
		ENDCG
	
	
	}
	
	FallBack "Diffuse"
}
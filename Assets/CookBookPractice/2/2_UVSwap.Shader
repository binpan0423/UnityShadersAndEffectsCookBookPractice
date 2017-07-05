Shader "MyCkBook/2_UVSwap"
{
	Properties
	{
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_MainTex("_MainText",2D) = "White"{}
		_ScroolXSpeed("_ScroolXSpeed",Range(0,10)) = 2
		_ScroolYSpeed("_ScroolYSpeed",Range(0,10)) = 2
		
		
	}
	
	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		fixed4 _MainTint;
		sampler2D _MainTex;
		fixed _ScroolXSpeed;
		fixed _ScroolYSpeed;
		
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN,inout SurfaceOutput o)
		{
			fixed2 scrooledUV = IN.uv_MainTex;
			
			fixed xScroolValue = _ScroolXSpeed * _Time;
			fixed yScroolValue = _ScroolYSpeed * _Time;
			
			scrooledUV += fixed2(xScroolValue,yScroolValue);
			
			half4 c = tex2D(_MainTex,scrooledUV);
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
			
		}
		
		
		
		ENDCG
	
	}
	
	FallBack "Diffuse"

}
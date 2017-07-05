Shader "MyCkBook/2_SpriteSheet"
{
	Properties
	{
		_MainTex("_MainTex(RGB)",2D) = "White"{}
		_Speed("_Speed",float) = 12
		_RowCount("_RowCount",Range(0,100)) = 10
	    _ColumeCount("_ColumeCount",Range(1,100)) = 10
	}
	
	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Lambert
		
		sampler2D _MainTex;
		float _Speed;
		int _ColumeCount;
		int _RowCount;
		
		struct Input
		{
			fixed2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed2 uv = IN.uv_MainTex;
			
			//float4 Time (t/20, t, t*2, t*3), use to animate things inside the shaders.
			float timeDelta = fmod(_Time.y*_Speed,_RowCount);
			timeDelta = ceil(timeDelta);
			
			fixed x = uv.x + timeDelta;
			x *= (float)1/_RowCount;
			
			fixed4 c = tex2D(_MainTex,float2(x,uv.y));
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	FallBack "Diffuse"

}



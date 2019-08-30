Shader "YoyoTest/BlurTest"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BlurSize("Blur Size", Range(0,1)) = 1
	}
		SubShader
		{
			Tags  {"Queue" = "Transparent" "RenderPipeline" = "LightweightPipeline" "RenderType" = "Opaque"}

			Pass
			{
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl"

				struct Attributes
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct Varyings
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float4 screenCoord : TEXCOORD1;
					float blurUV[5]:TEXCOORD2;
				};

				CBUFFER_START(UnityPerMaterial)

				TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
				half4 _MainTex_TexelSize;
				sampler2D _CameraOpaqueTexture;

				float _BlurSize;
				CBUFFER_END

				float4 ComputeGrabScreenPos(float4 pos) {
	#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
	#else
					float scale = 1.0;
	#endif
					float4 o = pos * 0.5f;
					o.xy = float2(o.x, o.y*scale) + o.w;
					o.zw = pos.zw;
					return o;
				}

				Varyings vert(Attributes v)
				{
					Varyings o;
					VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
					o.vertex = vertexInput.positionCS;

					o.uv = v.uv;
					o.screenCoord = ComputeGrabScreenPos(o.vertex);

					o.blurUV[0] = 0;
					o.blurUV[1] =  + float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
					o.blurUV[2] =  - float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
					o.blurUV[3] =  + float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
					o.blurUV[4] =  - float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
					return o;
				}


				half4  frag(Varyings i) : SV_Target
				{
					float weight[3] = {0.4026, 0.2442, 0.0545};//高斯的权重
					half4 col = tex2Dproj(_CameraOpaqueTexture, i.screenCoord)* weight[0] ;
					for (int j = 1; j < 3; j++) {
						col += tex2Dproj(_CameraOpaqueTexture, i.screenCoord +  i.blurUV[2 * j - 1]) * weight[j];
						col += tex2Dproj(_CameraOpaqueTexture, i.screenCoord + i.blurUV[2 * j]) * weight[j];
					}
					return col;
				}
				ENDHLSL
			}
		}
}

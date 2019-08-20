Shader "YoyoTest/InstanceTest"
{
	Properties
	{
		//_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
		{
			Tags  {"RenderPipeline" = "LightweightPipeline" "RenderType" = "Opaque"}

			Pass
			{
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl"
				#pragma multi_compile_instancing

				struct Attributes
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct Varyings
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				CBUFFER_START(UnityPerMaterial)

				TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
				half4 _MainTex_TexelSize;
				sampler2D _CameraOpaqueTexture;

				float _BlurSize;

				UNITY_INSTANCING_BUFFER_START(Props)
					UNITY_DEFINE_INSTANCED_PROP(float4, _ColorTest)
				UNITY_INSTANCING_BUFFER_END(Props)


				CBUFFER_END

				Varyings vert(Attributes v)
				{
					Varyings o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);

					VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
					o.vertex = vertexInput.positionCS;

					o.uv = v.uv;
					return o;
				}


				half4  frag(Varyings i) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(i);
					float4 colorInstanced = UNITY_ACCESS_INSTANCED_PROP(Props, _ColorTest);
					return colorInstanced;
				}
				ENDHLSL
			}
		}
}

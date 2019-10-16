Shader "YoyoTest/InstanceTest"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "white" {}

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
					float3 normal : NORMAL;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct Varyings
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float4 normalDir : TEXCOORD1;
					float4 tangentDir : TEXCOORD2;
					float4 bitangentDir : TEXCOORD3;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				CBUFFER_START(UnityPerMaterial)

				TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
				TEXTURE2D(_NormalTex); SAMPLER(sampler_NormalTex);

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

					VertexNormalInputs normalInput = GetVertexNormalInputs(v.normal);
					o.normalDir.xyz = normalInput.normalWS;
					o.tangentDir.xyz = normalInput.tangentWS;
					o.bitangentDir.xyz = normalInput.bitangentWS;

					float3 worldPos = vertexInput.positionWS;
					o.normalDir.w = worldPos.x;
					o.tangentDir.w = worldPos.y;
					o.bitangentDir.w = worldPos.z;
					return o;
				}


				half4  frag(Varyings i) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(i);
					half3 colorInstanced = UNITY_ACCESS_INSTANCED_PROP(Props, _ColorTest);

					float3 worldPos = float3(i.normalDir.w, i.tangentDir.w, i.bitangentDir.w);

					half3x3 tangentTransform = half3x3(i.tangentDir.xyz, i.bitangentDir.xyz, i.normalDir.xyz);
					half3 tangentNormal = UnpackNormal(SAMPLE_TEXTURE2D(_NormalTex, sampler_NormalTex,i.uv));
					float3 worldNormal = normalize(mul(tangentNormal, tangentTransform));//左乘到世界坐标系

					half4 mainColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);


					//_MainLightPosition
					//_MainLightColor

					//_AdditionalLightsPosition
					//_AdditionalLightsColor




					float3 lightDirection = normalize(_MainLightPosition);
					float LdotN = max(0.001, dot(lightDirection, worldNormal));//避免被除以0



					half3 additionLight = half3(0,0,0);
					half3 additionLightColor = half3(0, 0, 0);

					int pixelLightCount =GetAdditionalLightsCount();
					for (int i = 0; i < pixelLightCount; i++)
					{
						Light light = GetAdditionalLight(i, worldPos);
						additionLightColor = light.color * light.distanceAttenuation;
						additionLight += LightingLambert(additionLightColor, light.direction, worldNormal);
					}


					half3 mainLight = _MainLightColor * LdotN;


					half4 final = half4(mainColor.rgb *  (mainLight + additionLight), 1);

//#ifdef _ADDITIONAL_LIGHTS_VERTEX
//					int pixelLightCount = GetAdditionalLightsCount();
//					for (int i = 0; i < pixelLightCount; ++i)
//					{
//						Light light = GetAdditionalLight(i, positionWS);
//						half3 lightColor = light.color * light.distanceAttenuation;
//						vertexLightColor += LightingLambert(lightColor, light.direction, normalWS);
//					}
//#endif 
//
					return final;
				}
				ENDHLSL
			}

		}
}

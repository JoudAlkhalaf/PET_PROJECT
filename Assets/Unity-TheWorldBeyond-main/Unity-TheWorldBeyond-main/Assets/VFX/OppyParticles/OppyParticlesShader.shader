/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * Licensed under the Oculus SDK License Agreement (the "License");
 * you may not use the Oculus SDK except in compliance with the License,
 * which is provided at the time of installation or download, or which
 * otherwise accompanies this software in either electronic or hard copy form.
 *
 * You may obtain a copy of the License at
 *
 * https://developer.oculus.com/licenses/oculussdk/
 *
 * Unless required by applicable law or agreed to in writing, the Oculus SDK
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

Shader "TheWorldBeyond/OppyParticlesShader"
{
	Properties{
	    _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
	    _Cutoff("Alpha cutoff", Range(0,1)) = 0.5
		_Color("Color", Color) = (0,0,0,0)
	}
		SubShader{
			Tags{ "RenderType" = "Transparent" "Queue" = "Transparent"}

			LOD 100
			ZWrite Off
			Lighting Off

			Pass {
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma target 2.0

					#include "UnityCG.cginc"

					struct appdata_t {
						float4 vertex : POSITION;
						float2 texcoord : TEXCOORD0;
						float4 color : COLOR;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct v2f {
						float4 vertex : SV_POSITION;
						float2 texcoord : TEXCOORD0;
						float4 vertexColor : COLOR;
						UNITY_VERTEX_OUTPUT_STEREO
					};

					sampler2D _MainTex;
					float4 _MainTex_ST;
					fixed _Cutoff;
					uniform half4 _Color;

					v2f vert(appdata_t v)
					{
						v2f o;
						UNITY_SETUP_INSTANCE_ID(v);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						o.vertex = UnityObjectToClipPos(v.vertex);
						o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
						o.vertexColor = v.color;
						return o;
					}

					fixed4 frag(v2f i) : SV_Target
					{
						half4 Color = tex2D(_MainTex, i.texcoord) * i.vertexColor * _Color;
					//	half4 finalCol = (i.vertexColor.rgb, particleTexture.a * i.vertexColor.a);
					//	clip(col.a - _Cutoff);
						return Color;
					}
				ENDCG
			}
	}
}

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AIOsky/Simple01A"
{
	Properties
	{
		_sunColor("sunColor", Color) = (1,1,1,1)
		_sunMin("sunMin", Range( 0 , 5)) = 0.0006
		_SunGlow("SunGlow", Range( 0 , 10)) = 0.02
		_DayRange("DayRange", Range( -0.2 , 0.5)) = 0
		_NightRange("NightRange", Range( 0 , 0.5)) = 0
		_DayCoLorPos("DayCoLorPos", Range( 0 , 1)) = 0
		_DayColorSoft("DayColorSoft", Range( 0 , 1)) = 0
		_DayColor01("DayColor01", Color) = (0.2794118,0.5527384,1,0)
		_DayColor02("DayColor02", Color) = (0.2794118,0.5527384,1,0)
		_Night_Sky("Night_Sky", 2D) = "white" {}
		_BGscale("BGscale", Range( 0 , 0.5)) = 0.418
		_BGRotate("BGRotate", Range( -7 , 7)) = 0
		_CloudTexture("CloudTexture", 2D) = "white" {}
		_CloudMask("CloudMask", 2D) = "white" {}
		_DomeCurved("DomeCurved", Range( -1 , 1)) = 0
		_CloudFadeOut("CloudFadeOut", Range( -1 , 0)) = 0
		_CloudsDensity("CloudsDensity", Range( -1 , 1)) = 0.3
		_CloudsThickness("CloudsThickness", Range( 0.0001 , 1)) = 0.15
		_CloudScale("CloudScale", Range( 0 , 100)) = 0
		_CloudRotate("CloudRotate", Range( -6 , 6)) = 0
		_CloudOffset("CloudOffset", Vector) = (0,0,0,0)
		_DayCloudBrightness("DayCloudBrightness", Range( -1 , 1)) = 0
		_NightCloudBrightness("NightCloudBrightness", Range( -1 , 1)) = 0
		_CloudHue("CloudHue", Range( 0 , 1)) = 0
		_CloudSaturation("CloudSaturation", Range( 0 , 1)) = 0
		_CloudSpeed("CloudSpeed", Range( 0 , 0.2)) = 0
		_Ground("Ground", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  "PreviewType"="Skybox" }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
			float3 viewDir;
		};

		uniform half4 _sunColor;
		uniform half _sunMin;
		uniform half _SunGlow;
		uniform sampler2D _Night_Sky;
		uniform half _BGscale;
		uniform half _BGRotate;
		uniform half4 _DayColor01;
		uniform half4 _DayColor02;
		uniform half _DayCoLorPos;
		uniform half _DayColorSoft;
		uniform half _DayRange;
		uniform half _NightRange;
		uniform half _CloudHue;
		uniform half _CloudSaturation;
		uniform sampler2D _CloudTexture;
		uniform half _CloudRotate;
		uniform half _CloudScale;
		uniform half _DomeCurved;
		uniform half2 _CloudOffset;
		uniform half _CloudSpeed;
		uniform half _DayCloudBrightness;
		uniform half _NightCloudBrightness;
		uniform sampler2D _CloudMask;
		uniform half _CloudsDensity;
		uniform half _CloudsThickness;
		uniform half _CloudFadeOut;
		uniform half4 _Ground;


		inline float SafeRemap1183( float value , float low1 , float high1 , float low2 , float high2 )
		{
			return low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);
		}


		inline float SafeRemap1193( float value , float low1 , float high1 , float low2 , float high2 )
		{
			return low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);
		}


		inline float SafeRemap1188( float value , float low1 , float high1 , float low2 , float high2 )
		{
			return low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);
		}


		half3 HSVToRGB( half3 c )
		{
			half4 K = half4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			half3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline float MyCustomExpression1229( float InY , float InS , float InH )
		{
			return 1/(InS*InY-InS*InH);
		}


		inline float SafeRemap1222( float value , float low1 , float high1 , float low2 , float high2 )
		{
			return low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult1200 = normalize( i.viewDir );
			float3 VirDirFix1201 = normalizeResult1200;
			float dotResult1085 = dot( ase_worldlightDir , VirDirFix1201 );
			float value1183 = ( ( dotResult1085 + 1.0 ) * 100.0 );
			float low11183 = _sunMin;
			float high11183 = ( _sunMin * _SunGlow );
			float low21183 = 1.0;
			float high21183 = 0.0;
			float localSafeRemap1183 = SafeRemap1183( value1183 , low11183 , high11183 , low21183 , high21183 );
			float clampResult1100 = clamp( localSafeRemap1183 , 0.0 , 1.0 );
			float3 break1001 = VirDirFix1201;
			float3 appendResult1007 = (half3(break1001.x , ( ( break1001.y + -0.5 ) * 2.0 ) , break1001.z));
			float3 normalizeResult1009 = normalize( appendResult1007 );
			float cos1023 = cos( _BGRotate );
			float sin1023 = sin( _BGRotate );
			float2 rotator1023 = mul( ( ( (normalizeResult1009).xz * _BGscale ) + float2( 0.5,0.5 ) ) - float2( 0.5,0.5 ) , float2x2( cos1023 , -sin1023 , sin1023 , cos1023 )) + float2( 0.5,0.5 );
			float value1193 = (VirDirFix1201).y;
			float low11193 = ( _DayCoLorPos - _DayColorSoft );
			float high11193 = _DayCoLorPos;
			float low21193 = 0.0;
			float high21193 = 1.0;
			float localSafeRemap1193 = SafeRemap1193( value1193 , low11193 , high11193 , low21193 , high21193 );
			float clampResult1194 = clamp( localSafeRemap1193 , 0.0 , 1.0 );
			float4 lerpResult1171 = lerp( _DayColor01 , _DayColor02 , clampResult1194);
			float value1188 = ase_worldlightDir.y;
			float low11188 = ( _DayRange - _NightRange );
			float high11188 = _DayRange;
			float low21188 = 0.0;
			float high21188 = 1.0;
			float localSafeRemap1188 = SafeRemap1188( value1188 , low11188 , high11188 , low21188 , high21188 );
			float clampResult1151 = clamp( localSafeRemap1188 , 0.0 , 1.0 );
			float4 lerpResult1143 = lerp( tex2D( _Night_Sky, rotator1023 ) , lerpResult1171 , clampResult1151);
			float4 clampResult1153 = clamp( ( ( _sunColor * ( clampResult1100 * clampResult1100 ) ) + lerpResult1143 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float3 break1103 = VirDirFix1201;
			float2 appendResult1111 = (half2(break1103.x , break1103.z));
			float cos1104 = cos( _CloudRotate );
			float sin1104 = sin( _CloudRotate );
			float2 rotator1104 = mul( appendResult1111 - float2( 0,0 ) , float2x2( cos1104 , -sin1104 , sin1104 , cos1104 )) + float2( 0,0 );
			float InY1229 = break1103.y;
			float InS1229 = _CloudScale;
			float InH1229 = _DomeCurved;
			float localMyCustomExpression1229 = MyCustomExpression1229( InY1229 , InS1229 , InH1229 );
			float mulTime1123 = _Time.y * _CloudSpeed;
			float3 hsvTorgb1179 = HSVToRGB( half3(_CloudHue,_CloudSaturation,tex2D( _CloudTexture, ( ( rotator1104 * localMyCustomExpression1229 ) + _CloudOffset + mulTime1123 ) ).r) );
			float3 clampResult1175 = clamp( ( hsvTorgb1179 + ( clampResult1151 * _DayCloudBrightness ) + ( ( 1.0 - clampResult1151 ) * _NightCloudBrightness ) ) , float3( 0,0,0 ) , float3( 1,0.997,1 ) );
			float temp_output_1155_0 = ( _CloudsDensity + _CloudsThickness );
			float clampResult1156 = clamp( tex2D( _CloudMask, ( ( rotator1104 * localMyCustomExpression1229 ) + _CloudOffset + mulTime1123 ) ).r , _CloudsDensity , temp_output_1155_0 );
			float value1222 = (VirDirFix1201).y;
			float low11222 = _CloudFadeOut;
			float high11222 = ( _CloudFadeOut + 0.05 );
			float low21222 = 1.0;
			float high21222 = 0.0;
			float localSafeRemap1222 = SafeRemap1222( value1222 , low11222 , high11222 , low21222 , high21222 );
			float clampResult1225 = clamp( localSafeRemap1222 , 0.0 , 1.0 );
			float4 lerpResult1131 = lerp( clampResult1153 , half4( clampResult1175 , 0.0 ) , ( (0.0 + (clampResult1156 - _CloudsDensity) * (1.0 - 0.0) / (temp_output_1155_0 - _CloudsDensity)) * clampResult1225 ));
			float4 lerpResult1166 = lerp( lerpResult1131 , _Ground , step( 0.0 , (VirDirFix1201).y ));
			o.Emission = lerpResult1166.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
136;135;1754;687;1005.988;-1315.448;2.611613;True;True
Node;AmplifyShaderEditor.CommentaryNode;1217;-430.7498,-1215.911;Float;False;663.2189;234;Build in ViewDir Safe sometime no work;3;1199;1200;1201;ViewDir Normalize;1,0,0,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1199;-380.7498,-1165.911;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;1200;-186.535,-1161.648;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;998;-948.227,328.2881;Float;False;2905.179;681.0995;Project star nigth sky;13;1024;1023;1019;1018;1010;1009;1007;1006;1003;1001;424;429;1205;NightSky;0.1849049,0.2671221,0.6617647,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1201;-11.64863,-1163.34;Float;False;VirDirFix;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1205;-833.2328,607.288;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1102;371.725,2485.369;Float;False;1199.902;775.5291;;9;1112;1110;1123;1104;1128;1111;1103;1206;1229;CloudUV;0.8455882,0.5720156,0.1616566,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1001;-617.1488,566.214;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;1206;403.8207,2555.466;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1003;-331.7513,704.6379;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1103;627.3755,2539.281;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1115;45.67169,2729.819;Float;False;Property;_CloudRotate;CloudRotate;19;0;Create;True;0;0;False;0;0;6.6;-6;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1006;-141.8758,701.0749;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1142;974.2018,1136.877;Float;False;1012.887;538.6245;Control by Sun direction;6;1135;1137;1145;1151;1188;1192;DayControl;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1101;1012.997,-1201.531;Float;False;1458.386;590.6036;;12;1030;311;321;1085;333;1100;1183;1185;1186;1184;1187;1202;SUN;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;1128;1057.627,2718.47;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1114;33.33437,3065.272;Float;False;Property;_CloudScale;CloudScale;18;0;Create;True;0;0;False;0;0;25.9;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1230;23.55269,2626.484;Float;False;Property;_DomeCurved;DomeCurved;14;0;Create;True;0;0;False;0;0;0.086;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1030;1041.192,-1146.603;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1202;1100.499,-721.8371;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1137;1000.202,1402.102;Float;False;Property;_DayRange;DayRange;3;0;Create;True;0;0;False;0;0;-0.1;-0.2;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1111;919.61,2538.092;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1007;64.46161,558.038;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1135;1005.203,1511.902;Float;False;Property;_NightRange;NightRange;4;0;Create;True;0;0;False;0;0;0.2;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1125;26.50771,3161.295;Float;False;Property;_CloudSpeed;CloudSpeed;25;0;Create;True;0;0;False;0;0;0.0066;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;1229;847.678,2850.555;Float;False;1/(InS*InY-InS*InH);1;False;3;True;InY;FLOAT;0;In;;True;InS;FLOAT;0;In;;True;InH;FLOAT;0;In;;My Custom Expression;True;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;1104;1124.635,2549.433;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1145;1027.823,1206.536;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;1085;1333.529,-1097.654;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1192;1373.455,1467.381;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1133;728.3775,-393.2614;Float;False;1156.529;568.7114;Mix 2 Color for Day Sky;10;1132;1169;1171;1193;1194;1195;1196;1197;1203;1204;DaySky;0.6515463,0.7911913,0.8602941,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;1009;261.7617,553.646;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;1123;605.3777,3140.857;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1122;63.63913,2815.211;Float;False;Property;_CloudOffset;CloudOffset;20;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;1228;388.3158,1882.762;Float;False;873.4192;395.6365;;6;1227;1221;1226;1220;1222;1225;CloudFadeOut;0.5449827,0.6060136,0.7058823,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1110;1176.73,2862.337;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1196;754.2968,91.27047;Float;False;Property;_DayColorSoft;DayColorSoft;6;0;Create;True;0;0;False;0;0;0.563;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;424;435.0853,783.0889;Float;False;Property;_BGscale;BGscale;10;0;Create;True;0;0;False;0;0.418;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1203;744.1977,-121.922;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;311;1317.532,-956.9717;Float;False;Property;_sunMin;sunMin;1;0;Create;True;0;0;False;0;0.0006;0.05;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1184;1591.461,-1112.713;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1010;451.6793,550.33;Float;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;1188;1580.281,1326.26;Float;False;low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);1;False;5;True;value;FLOAT;0;In;;True;low1;FLOAT;-1;In;;True;high1;FLOAT;1;In;;True;low2;FLOAT;0;In;;True;high2;FLOAT;1;In;;SafeRemap;True;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;1318.161,-870.3407;Float;False;Property;_SunGlow;SunGlow;2;0;Create;True;0;0;False;0;0.02;5.53;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1195;747.7958,-17.92975;Float;False;Property;_DayCoLorPos;DayCoLorPos;5;0;Create;True;0;0;False;0;0;0.231;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1221;438.316,1932.762;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1112;1391.551,3094.524;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1151;1818.67,1335.761;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1197;1060.019,72.03527;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1187;1738.654,-1115.11;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1018;823.0254,550.8879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1185;1695.62,-944.5269;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1218;82.45903,2021.865;Float;False;Property;_CloudFadeOut;CloudFadeOut;15;0;Create;True;0;0;False;0;0;-0.078;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1159;2310.686,1883.525;Float;False;1232.398;1171.909;;14;1175;1157;1174;1156;1179;1155;1129;1126;1120;1119;1215;1214;1213;1216;CloudTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1227;558.6946,2191.525;Float;False;Constant;_Float0;Float 0;27;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1204;951.0173,-118.0205;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1119;2329.887,2399.503;Float;True;Property;_CloudTexture;CloudTexture;12;0;Create;True;0;0;False;0;None;7433e262603555048b50c53d719ff119;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CustomExpressionNode;1193;1266.832,1.073912;Float;False;low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);1;False;5;True;value;FLOAT;0;In;;True;low1;FLOAT;-1;In;;True;high1;FLOAT;1;In;;True;low2;FLOAT;0;In;;True;high2;FLOAT;1;In;;SafeRemap;True;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1220;643.2432,1934.693;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1226;737.5663,2060.399;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1216;2368.807,1934.422;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1130;2124.938,2580.712;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1019;990.4232,549.6379;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;1183;1985.714,-1055.038;Float;False;low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);1;False;5;True;value;FLOAT;0;In;;True;low1;FLOAT;-1;In;;True;high1;FLOAT;1;In;;True;low2;FLOAT;1;In;;True;high2;FLOAT;0;In;;SafeRemap;True;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;429;818.9235,789.6459;Float;False;Property;_BGRotate;BGRotate;11;0;Create;True;0;0;False;0;0;0.67;-7;7;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;1023;1135.954,547.952;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;1222;875.1561,1960.013;Float;False;low2 + (value - low1) * (high2 - low2) /max( (high1 - low1),0.0000001);1;False;5;True;value;FLOAT;0;In;;True;low1;FLOAT;0;In;;True;high1;FLOAT;0;In;;True;low2;FLOAT;1;In;;True;high2;FLOAT;0;In;;SafeRemap;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1173;2017.286,1963.775;Float;False;Property;_DayCloudBrightness;DayCloudBrightness;21;0;Create;True;0;0;False;0;0;0.249;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1181;1991.842,2252.09;Float;False;Property;_CloudHue;CloudHue;23;0;Create;True;0;0;False;0;0;0.111;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;2024.69,2969.799;Float;False;Property;_CloudsThickness;CloudsThickness;17;0;Create;True;0;0;False;0;0.15;0.245;0.0001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1212;2003.304,2133.346;Float;False;Property;_NightCloudBrightness;NightCloudBrightness;22;0;Create;True;0;0;False;0;0;-0.335;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1180;1993.842,2329.09;Float;False;Property;_CloudSaturation;CloudSaturation;24;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1169;1159.58,-364.6509;Float;False;Property;_DayColor01;DayColor01;7;0;Create;True;0;0;False;0;0.2794118,0.5527384,1,0;0.1764706,0.2751187,0.4705882,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1132;1191.342,-194.5354;Float;False;Property;_DayColor02;DayColor02;8;0;Create;True;0;0;False;0;0.2794118,0.5527384,1,0;0.6399762,0.8520784,0.9779412,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;223;2017.272,2863.186;Float;False;Property;_CloudsDensity;CloudsDensity;16;0;Create;True;0;0;False;0;0.3;0.282;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1100;2158.475,-1054.44;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1215;2474.799,2123.056;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1194;1498.618,-3.958802;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1126;2335.392,2665.859;Float;True;Property;_CloudMask;CloudMask;13;0;Create;True;0;0;False;0;None;7433e262603555048b50c53d719ff119;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;1120;2619.877,2397.063;Float;True;Property;_TextureSample3;Texture Sample 3;49;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1171;1618.913,-238.4136;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.HSVToRGBNode;1179;2938.896,2311.358;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1186;2327.413,-1049.218;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;333;2134.488,-817.9275;Float;False;Property;_sunColor;sunColor;0;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1155;2906.411,2952.111;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1225;1086.734,2003.49;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1214;2670.012,2124.302;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1213;2659.008,1935.956;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1129;2624.722,2639.762;Float;True;Property;_TextureSample4;Texture Sample 4;48;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1024;1513.27,564.892;Float;True;Property;_Night_Sky;Night_Sky;9;0;Create;True;0;0;False;0;None;890a2aacff3ca5c4ba27c56502c77836;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1161;2911.151,-117.3805;Float;False;617.4387;402.8309;;3;1152;1153;1154;SunComposite;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1160;2356.352,525.3956;Float;False;315;303;Mix Day& Night Sky;1;1143;SkyComposite;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;1156;3101.264,2859.86;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1143;2406.352,575.3956;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1154;2961.151,-67.38052;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1232;1763.483,2025.175;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1174;3153.616,2220.686;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1157;3309.539,2717.525;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1207;3758.406,2259.48;Float;False;1201;0;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1231;2263.814,1634.285;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1175;3320.06,2209.111;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0.997,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1167;3798.475,1897.812;Float;False;508.9392;516.3953;;3;1162;1208;1164;Ground;0.1459775,0.5514706,0.2158901,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1152;3179.817,124.7484;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1153;3353.59,129.4503;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1165;3734.75,1157.634;Float;False;234;206;Clouds + Sky;1;1131;Clouds Composite;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;1224;3548.896,1444.688;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;1208;3942.641,2258.454;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1223;3634.497,1578.022;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1168;4137.377,1014.485;Float;False;234;206;;1;1166;GroundComposite;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;1164;4165.447,2237.115;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1131;3784.75,1207.634;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1162;3889.147,1943.439;Float;False;Property;_Ground;Ground;26;0;Create;True;0;0;False;0;0,0,0,0;0.365814,0.4191176,0.2157223,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1166;4196.74,1064.485;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4784.46,878.3096;Half;False;True;0;Half;ASEMaterialInspector;0;0;Unlit;AIOsky/Simple01A;False;False;False;False;True;True;True;False;True;True;False;False;False;False;False;True;True;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Background;;Background;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;27;-1;-1;-1;1;PreviewType=Skybox;False;0;0;False;-1;-1;0;False;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1200;0;1199;0
WireConnection;1201;0;1200;0
WireConnection;1001;0;1205;0
WireConnection;1003;0;1001;1
WireConnection;1103;0;1206;0
WireConnection;1006;0;1003;0
WireConnection;1128;0;1115;0
WireConnection;1111;0;1103;0
WireConnection;1111;1;1103;2
WireConnection;1007;0;1001;0
WireConnection;1007;1;1006;0
WireConnection;1007;2;1001;2
WireConnection;1229;0;1103;1
WireConnection;1229;1;1114;0
WireConnection;1229;2;1230;0
WireConnection;1104;0;1111;0
WireConnection;1104;2;1128;0
WireConnection;1085;0;1030;0
WireConnection;1085;1;1202;0
WireConnection;1192;0;1137;0
WireConnection;1192;1;1135;0
WireConnection;1009;0;1007;0
WireConnection;1123;0;1125;0
WireConnection;1110;0;1104;0
WireConnection;1110;1;1229;0
WireConnection;1184;0;1085;0
WireConnection;1010;0;1009;0
WireConnection;1188;0;1145;2
WireConnection;1188;1;1192;0
WireConnection;1188;2;1137;0
WireConnection;1112;0;1110;0
WireConnection;1112;1;1122;0
WireConnection;1112;2;1123;0
WireConnection;1151;0;1188;0
WireConnection;1197;0;1195;0
WireConnection;1197;1;1196;0
WireConnection;1187;0;1184;0
WireConnection;1018;0;1010;0
WireConnection;1018;1;424;0
WireConnection;1185;0;311;0
WireConnection;1185;1;321;0
WireConnection;1204;0;1203;0
WireConnection;1193;0;1204;0
WireConnection;1193;1;1197;0
WireConnection;1193;2;1195;0
WireConnection;1220;0;1221;0
WireConnection;1226;0;1218;0
WireConnection;1226;1;1227;0
WireConnection;1216;0;1151;0
WireConnection;1130;0;1112;0
WireConnection;1019;0;1018;0
WireConnection;1183;0;1187;0
WireConnection;1183;1;311;0
WireConnection;1183;2;1185;0
WireConnection;1023;0;1019;0
WireConnection;1023;2;429;0
WireConnection;1222;0;1220;0
WireConnection;1222;1;1218;0
WireConnection;1222;2;1226;0
WireConnection;1100;0;1183;0
WireConnection;1215;0;1216;0
WireConnection;1194;0;1193;0
WireConnection;1120;0;1119;0
WireConnection;1120;1;1130;0
WireConnection;1171;0;1169;0
WireConnection;1171;1;1132;0
WireConnection;1171;2;1194;0
WireConnection;1179;0;1181;0
WireConnection;1179;1;1180;0
WireConnection;1179;2;1120;1
WireConnection;1186;0;1100;0
WireConnection;1186;1;1100;0
WireConnection;1155;0;223;0
WireConnection;1155;1;224;0
WireConnection;1225;0;1222;0
WireConnection;1214;0;1215;0
WireConnection;1214;1;1212;0
WireConnection;1213;0;1216;0
WireConnection;1213;1;1173;0
WireConnection;1129;0;1126;0
WireConnection;1129;1;1130;0
WireConnection;1024;1;1023;0
WireConnection;1156;0;1129;1
WireConnection;1156;1;223;0
WireConnection;1156;2;1155;0
WireConnection;1143;0;1024;0
WireConnection;1143;1;1171;0
WireConnection;1143;2;1151;0
WireConnection;1154;0;333;0
WireConnection;1154;1;1186;0
WireConnection;1232;0;1225;0
WireConnection;1174;0;1179;0
WireConnection;1174;1;1213;0
WireConnection;1174;2;1214;0
WireConnection;1157;0;1156;0
WireConnection;1157;1;223;0
WireConnection;1157;2;1155;0
WireConnection;1231;0;1232;0
WireConnection;1175;0;1174;0
WireConnection;1152;0;1154;0
WireConnection;1152;1;1143;0
WireConnection;1153;0;1152;0
WireConnection;1224;0;1175;0
WireConnection;1208;0;1207;0
WireConnection;1223;0;1157;0
WireConnection;1223;1;1231;0
WireConnection;1164;1;1208;0
WireConnection;1131;0;1153;0
WireConnection;1131;1;1224;0
WireConnection;1131;2;1223;0
WireConnection;1166;0;1131;0
WireConnection;1166;1;1162;0
WireConnection;1166;2;1164;0
WireConnection;0;2;1166;0
ASEEND*/
//CHKSM=AAD46F1F7C5210613170C318DB49A087CE684B34
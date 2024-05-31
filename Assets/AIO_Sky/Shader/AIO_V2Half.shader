
Shader "AIOsky/V2Half"
{
	Properties
	{
		[Header(Sun)]
		_sunColor("sunColor", Color) = (1,1,1,1)
		_sunMin("sunMin", Range( 0 , 0.02)) = 0.0006
		_sunMax("sunMax", Range( 0.9 , 1)) = 1
		_SunGlow("SunGlow", Range( 0 , 0.2)) = 0.02
		[Space(10)]
		[Header(Sky)]
		_AtmosphereStart("AtmosphereStart", Range( -0.2 , 0.2)) = -0.2
		_AtmosphereEnd("AtmosphereEnd", Range( 0 , 1)) = 0.2
		_DaySky("DaySky", Color) = (0.2603806,0.5671997,0.8235294,0)
		_DayAtmosphere("DayAtmosphere", Color) = (0.7794118,0.8904663,1,0)
		_DayRange("DayRange", Range( -1 , 1)) = 0.4
		_SunSetSky("SunSetSky", Color) = (0.6838235,0.5643972,0.4726427,0)
		_SunSetAtmosphere("SunSetAtmosphere", Color) = (1,0.7294118,0.3882351,0)
		_setRange("setRange", Range( -1 , 1)) = 0.2
		_NightSky("NightSky", Color) = (0,0.01729209,0.08088226,0)
		_NightAtmosphere("NightAtmosphere", Color) = (0.13484,0.1548442,0.2132353,0)
		_nightRange("nightRange", Range( -1 , 1)) = -0.2
		[Space(10)]
		[Header(Main Clouds)]
		_BaseCloud("BaseCloud", 2D) = "white" {}
		_CloudsDensitySkyEdge("CloudsDensitySkyEdge", Range( 1 , 1.5)) = 0.3
		_CloudsDensity("CloudsDensity", Range( -1 , 1)) = 0.3
		_CloudsThickness("CloudsThickness", Range( 0.0001 , 0.3)) = 0.15
		_CloudDetail("CloudDetail", 2D) = "white" {}
		_DomeCurved("DomeCurved", Range( -2 , 2)) = 0.4
		_CloudsScale("CloudsScale", Range( 0 , 5)) = 1
		_DetailScale01("DetailScale01", Range( 0 , 2)) = 0.6
		_DetailScale02("DetailScale02", Range( 0 , 2)) = 0.2
		_DetailScale03("DetailScale03", Range( 0 , 2)) = 0.2
		[Space(10)]
		[Header(Daytime Clouds Color)]
		_SunLightPower("SunLightPower", Range( 0 , 10)) = 0.5
		
		_DayTransmissionColor("DayTransmissionColor", Color) = (0.5514706,0.7401621,1,1)
		_DayCloudsTransmission("DayCloudsTransmission", Range( 0 , 5)) = 1
		_AmbientLight("AmbientLight", Range( 0 , 1)) = 0.5
		
		_CloudsBrightness("CloudsBrightness", Range( -1 , 1)) = -0.5
		_CloudsContract("CloudsContract", Range( 0 , 1)) = 0.7
		[Space(10)]
		[Header(Night time Clouds Color)]
		_MoonLight("MoonLight", Color) = (0,0,0,0)
		_MoonLightPower("MoonLightPower", Range( 0 , 10)) = 0.5
		_NightTransmissionColor("NightTransmissionColor", Color) = (1,0.5342799,0.3970588,1)
		_NightCloudsTransmission("NightCloudsTransmission", Range( 0 , 5)) = 1
		_NightAmbientLight("NightAmbientLight", Range( 0 , 1)) = 0.5
		_NightCloudsBrightness("NightCloudsBrightness", Range( -1 , 1)) = -0.5
		_NightCloudsContract("NightCloudsContract", Range( 0 , 1)) = 0.7
		[Space(10)]
		[Header(Addtional Clouds Color)]		
		_CloudsShadowWeight("CloudsShadowWeight", Range( -2 , 2)) = -0.5
		_SunZoffset("SunZoffset", Range( -0.5 , 0.5)) = 0

		[Space(10)]
		[Header(Clouds animation)]
		_CloudsPan("CloudsPan", Vector) = (0,0,0,0)
		_CloudsRotation("CloudsRotation", Range( 0 , 7)) = 0
		_timeScale("timeScale", Range( 0 , 0.05)) = 0.002
		_DistortionTime("DistortionTime", Range( 0 , 0.05)) = 0.002
		[Space(10)]
		[Header(Starfield)]
		_StarField("StarField", 2D) = "white" {}
		_BGscale("BGscale", Range( 0 , 0.5)) = 0.418
		_BGRotate("BGRotate", Range( -7 , 7)) = -7
		_Moon("Moon", 2D) = "white" {}
		_MoonGlow("MoonGlow", 2D) = "white" {}
		_moonScale("moonScale", Range( 1 , 40)) = 10
		[HideInInspector]
		_MoonPosition("MoonPosition", Vector) = (0,0,0,0)
		[Space(10)]
		[Header(Ground)]
		_FogColor("FogColor", Color) = (0.2039214,0.1921567,0.1921567,0)
		_FogLevel("FogLevel", Range( 0 , 1)) = 0.05
		_GroundColor("GroundColor", Color) = (0.2058817,0.1937709,0.1937709,0)
		_GroundLevel("GroundLevel", Range( -0.5 , 0.85)) = 0.1
		[Space(10)]
		[Header(Normal map decode Method)]
		[Toggle]_ToggleRGAGNormal("Toggle RG/AG Normal", Float) = 0
		[HideInInspector][Toggle]_ToggleTest("Toggle Test", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  "PreviewType"="Skybox" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 2.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _ToggleTest;
		uniform float4 _FogColor;
		uniform float4 _GroundColor;
		uniform float _GroundLevel;
		uniform float _FogLevel;
		uniform float4 _DayTransmissionColor;
		uniform sampler2D _BaseCloud;
		uniform float _CloudsRotation;
		uniform float _CloudsScale;
		uniform float _DomeCurved;
		uniform float2 _CloudsPan;
		uniform float _timeScale;
		uniform sampler2D _CloudDetail;
		uniform float _DetailScale01;
		uniform float _DistortionTime;
		uniform float _DetailScale02;
		uniform float _DetailScale03;
		uniform float _setRange;
		uniform float _DayRange;
		uniform float _ToggleRGAGNormal;
		uniform float3 _MoonPosition;
		uniform float _SunZoffset;
		uniform float _nightRange;
		uniform float _DayCloudsTransmission;
		uniform float4 _NightTransmissionColor;
		uniform float _NightCloudsTransmission;
		uniform float _SunLightPower;
		uniform float4 _sunColor;
		uniform float4 _MoonLight;
		uniform float _MoonLightPower;
		uniform float4 _SunSetAtmosphere;
		uniform float4 _DayAtmosphere;
		uniform float4 _NightAtmosphere;
		uniform float _CloudsShadowWeight;
		uniform float _AmbientLight;
		uniform float _NightAmbientLight;
		uniform float _NightCloudsBrightness;
		uniform float _NightCloudsContract;
		uniform float _CloudsBrightness;
		uniform float _CloudsContract;
		uniform float _CloudsDensitySkyEdge;
		uniform float _CloudsDensity;
		uniform float _CloudsThickness;
		uniform float _sunMax;
		uniform float _sunMin;
		uniform sampler2D _Moon;
		uniform float _moonScale;
		uniform float4 _SunSetSky;
		uniform float4 _DaySky;
		uniform float4 _NightSky;
		uniform sampler2D _StarField;
		uniform float _BGscale;
		uniform float _BGRotate;
		uniform sampler2D _MoonGlow;
		uniform float _AtmosphereStart;
		uniform float _AtmosphereEnd;
		uniform float _SunGlow;


		inline float MyCustomExpression62_g228( float InY , float InS , float InH )
		{
			return 1/(InS*InY-InS*InH);
		}


		inline float MyCustomExpression62_g172( float InY , float InS , float InH )
		{
			return 1/(InS*InY-InS*InH);
		}


		inline float MyCustomExpression62_g227( float InY , float InS , float InH )
		{
			return 1/(InS*InY-InS*InH);
		}


		inline float MyCustomExpression62_g352( float InY , float InS , float InH )
		{
			return 1/(InS*InY-InS*InH);
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult1071 = normalize( ase_worldViewDir );
			float3 ViewDir1014 = normalizeResult1071;
			float ViewDirY797 = ViewDir1014.y;
			float clampResult2_g395 = clamp( (0.0 + (ViewDirY797 - 0.0) * (1.0 - 0.0) / (_GroundLevel - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult633 = lerp( _FogColor , _GroundColor , clampResult2_g395);
			float clampResult2_g396 = clamp( (0.0 + (ViewDirY797 - ( _GroundLevel - _FogLevel )) * (1.0 - 0.0) / (_GroundLevel - ( _GroundLevel - _FogLevel ))) , 0.0 , 1.0 );
			float temp_output_3_0_g398 = clampResult2_g396;
			float3 break100_g228 = ViewDir1014;
			float2 appendResult86_g228 = (float2(break100_g228.x , break100_g228.z));
			float cos87_g228 = cos( _CloudsRotation );
			float sin87_g228 = sin( _CloudsRotation );
			float2 rotator87_g228 = mul( appendResult86_g228 - float2( 0,0 ) , float2x2( cos87_g228 , -sin87_g228 , sin87_g228 , cos87_g228 )) + float2( 0,0 );
			float InY62_g228 = break100_g228.y;
			float temp_output_606_0 = ( _CloudsScale * 0.0001 );
			float temp_output_24_0_g228 = _DomeCurved;
			float InS62_g228 = ( temp_output_606_0 / max( ( break100_g228.y - temp_output_24_0_g228 ) , 1E-05 ) );
			float InH62_g228 = temp_output_24_0_g228;
			float localMyCustomExpression62_g228 = MyCustomExpression62_g228( InY62_g228 , InS62_g228 , InH62_g228 );
			float mulTime359 = _Time.y * _timeScale;
			float2 temp_output_804_0 = ( _CloudsPan + mulTime359 );
			float3 break100_g172 = ViewDir1014;
			float2 appendResult86_g172 = (float2(break100_g172.x , break100_g172.z));
			float cos87_g172 = cos( _CloudsRotation );
			float sin87_g172 = sin( _CloudsRotation );
			float2 rotator87_g172 = mul( appendResult86_g172 - float2( 0,0 ) , float2x2( cos87_g172 , -sin87_g172 , sin87_g172 , cos87_g172 )) + float2( 0,0 );
			float InY62_g172 = break100_g172.y;
			float temp_output_766_0 = ( temp_output_606_0 * _DetailScale01 );
			float temp_output_24_0_g172 = ( _DomeCurved + -0.05 );
			float InS62_g172 = ( temp_output_766_0 / max( ( break100_g172.y - temp_output_24_0_g172 ) , 1E-05 ) );
			float InH62_g172 = temp_output_24_0_g172;
			float localMyCustomExpression62_g172 = MyCustomExpression62_g172( InY62_g172 , InS62_g172 , InH62_g172 );
			float mulTime942 = _Time.y * _DistortionTime;
			float2 appendResult940 = (float2(mulTime942 , 0.0));
			float4 temp_output_772_0 = ( tex2D( _BaseCloud, ( ( ( rotator87_g228 * localMyCustomExpression62_g228 ) + float2( 0,0 ) ) + temp_output_804_0 ) ) + ( tex2D( _CloudDetail, ( ( ( rotator87_g172 * localMyCustomExpression62_g172 ) + float2( 0,0 ) ) + temp_output_804_0 + appendResult940 ) ) * 0.5 ) );
			float3 break100_g227 = ViewDir1014;
			float2 appendResult86_g227 = (float2(break100_g227.x , break100_g227.z));
			float cos87_g227 = cos( _CloudsRotation );
			float sin87_g227 = sin( _CloudsRotation );
			float2 rotator87_g227 = mul( appendResult86_g227 - float2( 0,0 ) , float2x2( cos87_g227 , -sin87_g227 , sin87_g227 , cos87_g227 )) + float2( 0,0 );
			float InY62_g227 = break100_g227.y;
			float temp_output_778_0 = ( temp_output_766_0 * _DetailScale02 );
			float temp_output_24_0_g227 = ( _DomeCurved + -0.1 );
			float InS62_g227 = ( temp_output_778_0 / max( ( break100_g227.y - temp_output_24_0_g227 ) , 1E-05 ) );
			float InH62_g227 = temp_output_24_0_g227;
			float localMyCustomExpression62_g227 = MyCustomExpression62_g227( InY62_g227 , InS62_g227 , InH62_g227 );
			float2 appendResult941 = (float2(0.0 , mulTime942));
			float3 break100_g352 = ViewDir1014;
			float2 appendResult86_g352 = (float2(break100_g352.x , break100_g352.z));
			float cos87_g352 = cos( _CloudsRotation );
			float sin87_g352 = sin( _CloudsRotation );
			float2 rotator87_g352 = mul( appendResult86_g352 - float2( 0,0 ) , float2x2( cos87_g352 , -sin87_g352 , sin87_g352 , cos87_g352 )) + float2( 0,0 );
			float InY62_g352 = break100_g352.y;
			float temp_output_24_0_g352 = ( _DomeCurved + -0.15 );
			float InS62_g352 = ( ( temp_output_778_0 * _DetailScale03 ) / max( ( break100_g352.y - temp_output_24_0_g352 ) , 1E-05 ) );
			float InH62_g352 = temp_output_24_0_g352;
			float localMyCustomExpression62_g352 = MyCustomExpression62_g352( InY62_g352 , InS62_g352 , InH62_g352 );
			float2 appendResult1057 = (float2(mulTime942 , mulTime942));
			float4 temp_output_775_0 = ( ( ( temp_output_772_0 + ( tex2D( _CloudDetail, ( ( ( rotator87_g227 * localMyCustomExpression62_g227 ) + float2( 0,0 ) ) + temp_output_804_0 + appendResult941 ) ) * 0.2 ) ) + ( tex2D( _CloudDetail, ( ( ( rotator87_g352 * localMyCustomExpression62_g352 ) + float2( 0,0 ) ) + temp_output_804_0 + appendResult1057 ) ) * 0.05 ) ) * float4(0.56,0.56,0.56,0.56) );
			float temp_output_596_0 = (temp_output_775_0).a;
			float cloudsBase862 = temp_output_596_0;
			float temp_output_879_0 = ( 1.0 - cloudsBase862 );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult1074 = normalize( ase_worldlightDir );
			float clampResult2_g365 = clamp( (0.0 + (normalizeResult1074.y - _setRange) * (1.0 - 0.0) / (_DayRange - _setRange)) , 0.0 , 1.0 );
			float temp_output_798_0 = clampResult2_g365;
			float DayControl901 = temp_output_798_0;
			float4 break812 = temp_output_775_0;
			float4 appendResult813 = (float4(1.0 , break812.g , 1.0 , break812.r));
			float4 break1068 = temp_output_775_0;
			float4 appendResult1069 = (float4(break1068.r , break1068.g , 1.0 , 1.0));
			float4 PackedNormal810 = lerp(appendResult813,appendResult1069,_ToggleRGAGNormal);
			float CloudsRotation738 = _CloudsRotation;
			float cos715 = cos( -CloudsRotation738 );
			float sin715 = sin( -CloudsRotation738 );
			float2 rotator715 = mul( (UnpackNormal( PackedNormal810 )).xy - float2( 0,0 ) , float2x2( cos715 , -sin715 , sin715 , cos715 )) + float2( 0,0 );
			float2 break822 = rotator715;
			float4 appendResult819 = (float4(-break822.x , UnpackNormal( PackedNormal810 ).z , -break822.y , 0.0));
			float3 MoonDir955 = _MoonPosition;
			float3 temp_output_957_0 = ( ViewDir1014 + MoonDir955 );
			float dotResult958 = dot( temp_output_957_0 , float3( 1,0,0 ) );
			float dotResult961 = dot( temp_output_957_0 , float3( 0,0,1 ) );
			float3 appendResult959 = (float3(dotResult958 , _SunZoffset , dotResult961));
			float3 normalizeResult960 = normalize( appendResult959 );
			float clampResult2_g366 = clamp( (0.0 + (normalizeResult1074.y - _setRange) * (1.0 - 0.0) / (_nightRange - _setRange)) , 0.0 , 1.0 );
			float nightControl484 = clampResult2_g366;
			float3 temp_output_817_0 = ( ViewDir1014 + ase_worldlightDir );
			float dotResult871 = dot( temp_output_817_0 , float3( 1,0,0 ) );
			float dotResult872 = dot( temp_output_817_0 , float3( 0,0,1 ) );
			float3 appendResult873 = (float3(dotResult871 , _SunZoffset , dotResult872));
			float3 normalizeResult892 = normalize( appendResult873 );
			float dotResult166 = dot( appendResult819 , float4( ( ( normalizeResult960 * nightControl484 ) + ( normalizeResult892 * DayControl901 ) ) , 0.0 ) );
			float4 temp_output_1032_0 = ( ( _DayTransmissionColor * temp_output_879_0 * DayControl901 * max( ( -dotResult166 + _DayCloudsTransmission ) , 0.0 ) ) + ( _NightTransmissionColor * temp_output_879_0 * ( 1.0 - DayControl901 ) * max( ( -dotResult166 + _NightCloudsTransmission ) , 0.0 ) ) );
			float4 temp_output_348_0 = ( _sunColor * temp_output_798_0 );
			float4 mySunColor349 = temp_output_348_0;
			float temp_output_847_0 = max( -dotResult166 , 0.0 );
			float4 temp_output_853_0 = ( ( ( _SunLightPower * mySunColor349 ) + ( _MoonLight * nightControl484 * _MoonLightPower ) ) * temp_output_847_0 * _SunLightPower );
			float4 clampResult1003 = clamp( ( temp_output_1032_0 + temp_output_853_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 lerpResult329 = lerp( _SunSetAtmosphere , _DayAtmosphere , temp_output_798_0);
			float4 lerpResult336 = lerp( lerpResult329 , _NightAtmosphere , clampResult2_g366);
			float4 BaseColor345 = lerpResult336;
			float temp_output_911_0 = ( cloudsBase862 * ( 1.0 - -dotResult166 ) );
			float4 lerpResult912 = lerp( clampResult1003 , ( BaseColor345 * max( temp_output_911_0 , 0.0 ) * _CloudsShadowWeight ) , temp_output_911_0);
			float4 clampResult951 = clamp( ( lerpResult912 + ( temp_output_596_0 * ( ( _AmbientLight * DayControl901 ) + ( _NightAmbientLight * ( 1.0 - DayControl901 ) ) ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float temp_output_7_0_g392 = _NightCloudsBrightness;
			float4 temp_cast_5 = (temp_output_7_0_g392).xxxx;
			float temp_output_4_0_g392 = ( temp_output_7_0_g392 + _NightCloudsContract );
			float4 temp_cast_6 = (temp_output_4_0_g392).xxxx;
			float4 clampResult2_g392 = clamp( clampResult951 , temp_cast_5 , temp_cast_6 );
			float4 temp_cast_7 = (temp_output_7_0_g392).xxxx;
			float4 temp_cast_8 = (temp_output_4_0_g392).xxxx;
			float temp_output_7_0_g393 = _CloudsBrightness;
			float4 temp_cast_9 = (temp_output_7_0_g393).xxxx;
			float temp_output_4_0_g393 = ( temp_output_7_0_g393 + _CloudsContract );
			float4 temp_cast_10 = (temp_output_4_0_g393).xxxx;
			float4 clampResult2_g393 = clamp( clampResult951 , temp_cast_9 , temp_cast_10 );
			float4 temp_cast_11 = (temp_output_7_0_g393).xxxx;
			float4 temp_cast_12 = (temp_output_4_0_g393).xxxx;
			float4 lerpResult905 = lerp( (float4( 0,0,0,0 ) + (clampResult2_g392 - temp_cast_7) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (temp_cast_8 - temp_cast_7)) , (float4( 0,0,0,0 ) + (clampResult2_g393 - temp_cast_11) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (temp_cast_12 - temp_cast_11)) , DayControl901);
			float4 clampResult946 = clamp( lerpResult905 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float clampResult1043 = clamp( ( _CloudsDensitySkyEdge - ( 1.0 - ViewDirY797 ) ) , 0.0 , 1.0 );
			float clampResult1038 = clamp( ( break812.a + clampResult1043 ) , 0.0 , 1.0 );
			float temp_output_7_0_g394 = _CloudsDensity;
			float temp_output_4_0_g394 = ( temp_output_7_0_g394 + _CloudsThickness );
			float clampResult2_g394 = clamp( min( clampResult1038 , step( break100_g228.y , temp_output_24_0_g228 ) ) , temp_output_7_0_g394 , temp_output_4_0_g394 );
			float temp_output_3_0_g397 = (0.0 + (clampResult2_g394 - temp_output_7_0_g394) * (1.0 - 0.0) / (temp_output_4_0_g394 - temp_output_7_0_g394));
			float3 ViewDirNormal803 = ViewDir1014;
			float dotResult309 = dot( normalizeResult1074 , -ViewDirNormal803 );
			float clampResult2_g368 = clamp( (0.0 + (dotResult309 - ( _sunMax - _sunMin )) * (1.0 - 0.0) / (_sunMax - ( _sunMax - _sunMin ))) , 0.0 , 1.0 );
			float temp_output_800_0 = clampResult2_g368;
			float3 break409 = _MoonPosition;
			float3 appendResult678 = (float3(break409.x , ( ( break409.y + 0.5 ) * 2.0 ) , break409.z));
			float3 normalizeResult417 = normalize( appendResult678 );
			float3 break419 = normalizeResult417;
			float2 appendResult682 = (float2(( break419.x * _moonScale ) , ( break419.z * _moonScale )));
			float3 break408 = ViewDir1014;
			float3 appendResult677 = (float3(break408.x , ( ( break408.y + -0.5 ) * 2.0 ) , break408.z));
			float3 normalizeResult416 = normalize( appendResult677 );
			float2 temp_output_418_0 = (normalizeResult416).xz;
			float2 clampResult432 = clamp( ( appendResult682 + ( ( temp_output_418_0 * _moonScale ) + float2( 0.5,0.5 ) ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float4 tex2DNode434 = tex2D( _Moon, clampResult432 );
			float moonMask919 = tex2DNode434.a;
			float temp_output_921_0 = ( 1.0 - moonMask919 );
			float4 lerpResult327 = lerp( _SunSetSky , _DaySky , temp_output_798_0);
			float4 lerpResult335 = lerp( lerpResult327 , _NightSky , clampResult2_g366);
			float cos431 = cos( _BGRotate );
			float sin431 = sin( _BGRotate );
			float2 rotator431 = mul( ( ( temp_output_418_0 * _BGscale ) + float2( 0.5,0.5 ) ) - float2( 0.5,0.5 ) , float2x2( cos431 , -sin431 , sin431 , cos431 )) + float2( 0.5,0.5 );
			float4 lerpResult435 = lerp( tex2D( _StarField, rotator431 ) , tex2DNode434 , tex2DNode434.a);
			float4 MoonLightPowered986 = _MoonLight;
			float2 appendResult993 = (float2(break419.x , break419.z));
			float temp_output_1001_0 = ( 0.8 * _moonScale );
			float2 clampResult996 = clamp( ( ( appendResult993 * temp_output_1001_0 ) + ( ( temp_output_418_0 * temp_output_1001_0 ) + float2( 0.5,0.5 ) ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float4 tex2DNode464 = tex2D( _MoonGlow, clampResult996 );
			float4 clampResult985 = clamp( ( lerpResult435 + ( MoonLightPowered986 * tex2DNode464.r ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 lerpResult439 = lerp( ( lerpResult335 + ( tex2DNode434 * 0.1 * tex2DNode434.a ) ) , clampResult985 , clampResult2_g366);
			float smoothstepResult316 = smoothstep( _AtmosphereStart , _AtmosphereEnd , -ViewDirNormal803.y);
			float4 lerpResult338 = lerp( lerpResult439 , lerpResult336 , ( 1.0 - smoothstepResult316 ));
			float temp_output_337_0 = pow( (0.0 + (dotResult309 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , ( 1.0 / max( max( ( _SunGlow * ( 1.0 - temp_output_798_0 ) ) , ( _SunGlow * 0.02 ) ) , 0.0001 ) ) );
			float4 SkyOnly342 = ( ( temp_output_348_0 * temp_output_800_0 * _sunColor.a * temp_output_921_0 ) + lerpResult338 + ( temp_output_337_0 * lerpResult329 * _sunColor.a * temp_output_921_0 ) );
			float Test481 = (0.0 + (0.0 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float3 temp_cast_15 = (Test481).xxx;
			o.Emission = lerp(( ( lerpResult633.rgb * temp_output_3_0_g398 ) + ( ( ( clampResult946.rgb * temp_output_3_0_g397 ) + ( SkyOnly342.rgb * ( 1.0 - temp_output_3_0_g397 ) ) ) * ( 1.0 - temp_output_3_0_g398 ) ) ),temp_cast_15,_ToggleTest);
			o.Alpha = 1;
		}

		ENDCG
	}
	//CustomEditor "ASEMaterialInspector"
}

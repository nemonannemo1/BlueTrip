
Shader "AIOsky/Std01"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
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
		[Gamma]
		_CloudsDensity("CloudsDensity", Range( -1 , 1)) = 0.3
		[Gamma]
		_CloudsThickness("CloudsThickness", Range( 0 , 1)) = 0.15
		_CloudsBrightness("CloudsBrightness", Range( -1 , 1)) = -0.5
		_CloudsContract("CloudsContract", Range( 0 , 1)) = 0.7
		_CloudsShadowWeight("CloudsShadowWeight", Range( 0.1 , 10)) = 1.5
		_CloudsShadowBalance("CloudsShadowBalance", Range( 0 , 1)) = 0.5
		_CloudsTransmission("CloudsTransmission", Range( 0 , 2)) = 1.25
		_DomeCurved("DomeCurved", Range( -2 , 2)) = 0.4
		_CloudsScale("CloudsScale", Range( 0.5 , 10)) = 1.5
		_CloudsPan("CloudsPan", Vector) = (0,0,0,0)
		_CloudsRotation("CloudsRotation", Range( 0 , 7)) = 0
		_timeScale("timeScale", Range( 0 , 0.05)) = 0.002
		[Space(10)]
		[Header(Sub Clouds)]
		_DistortionTexture("DistortionTexture", 2D) = "white" {}
		_DistortionMin("DistortionMin", Range( 0 , 1)) = 0.6
		_DistortionMax("DistortionMax", Range( 0 , 0.01)) = 0.005
		_DistortionScale("DistortionScale", Range( 0 , 100)) = 10
		_DistortionPan("DistortionPan", Vector) = (0,0,0,0)
		_DistortionTime("DistortionTime", Range( 0 , 0.2)) = 0.012
		_normalTexture("normal Texture ", 2D) = "bump" {}
		_normalscale("normal scale", Range( -2 , 2)) = 1
		[Toggle]_normalMapenable("normal Map enable", Float) = 1
		[Space(10)]
		[Header(Starfield)]
		_StarField("StarField", 2D) = "white" {}
		_BGscale("BGscale", Range( 0.2 , 0.5)) = 0.418
		_BGRotate("BGRotate", Range( -7 , 7)) = 0
		_Moon("Moon", 2D) = "white" {}
		_MoonGlow("MoonGlow", 2D) = "white" {}
		_ExtraLight("ExtraLight", Color) = (0.75,0.75,0.75,0.75)
		_moonScale("moonScale", Range( 1 , 40)) = 10
		_MoonPosition("MoonPosition", Vector) = (0,0,0,0)
		[Space(10)]
		[Header(Ground)]
		_FogColor("FogColor", Color) = (0.2039214,0.1921567,0.1921567,0)
		_FogLevel("FogLevel", Range( 0 , 1)) = 0.05
		_GroundColor("GroundColor", Color) = (0.2058817,0.1937709,0.1937709,0)
		_GroundLevel("GroundLevel", Range( -0.5 , 0.85)) = 0.1
		[Space(30)]
		[Header(Reserve)]
		[Toggle]_ToggleExtra("Toggle Extra", Float) = 1
		[Toggle]_remapswitch("remap switch", Float) = 0
		_YScale("YScale", Range( -2 , 2)) = 1
		_DotOffset("DotOffset", Range( -1 , 1)) = 0
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "ForceNoShadowCasting" = "True" "IsEmissive" = "true" "PreviewType"="Skybox" }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0  //2.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float4 _sunColor;
		uniform float _setRange;
		uniform float _DayRange;
		uniform float _sunMax;
		uniform float _sunMin;
		uniform float4 _SunSetSky;
		uniform float4 _DaySky;
		uniform float4 _NightSky;
		uniform float _nightRange;
		uniform sampler2D _Moon;
		uniform float3 _MoonPosition;
		uniform float _moonScale;
		uniform sampler2D _StarField;
		uniform float _BGscale;
		uniform float _BGRotate;
		uniform float4 _SunSetAtmosphere;
		uniform float4 _DayAtmosphere;
		uniform float4 _NightAtmosphere;
		uniform float _AtmosphereStart;
		uniform float _AtmosphereEnd;
		uniform float _SunGlow;
		uniform float4 _ExtraLight;
		uniform sampler2D _MoonGlow;
		uniform fixed _ToggleExtra;
		uniform sampler2D _BaseCloud;
		uniform float4 _BaseCloud_TexelSize;
		uniform float _CloudsRotation;
		uniform float _CloudsScale;
		uniform float _DomeCurved;
		uniform float2 _CloudsPan;
		uniform float _timeScale;
		uniform sampler2D _DistortionTexture;
		uniform float _DistortionScale;
		uniform float2 _DistortionPan;
		uniform float _DistortionTime;
		uniform float _DistortionMax;
		uniform float _DistortionMin;
		uniform float _CloudsDensity;
		uniform float _CloudsThickness;
		uniform float _CloudsTransmission;
		uniform float _CloudsShadowWeight;
		uniform float _CloudsShadowBalance;
		uniform float _remapswitch;
		uniform fixed _normalMapenable;
		uniform sampler2D _normalTexture;
		uniform float _normalscale;
		uniform float _YScale;
		uniform float _DotOffset;
		uniform float _CloudsBrightness;
		uniform float _CloudsContract;
		uniform float4 _FogColor;
		uniform float4 _GroundColor;
		uniform float _GroundLevel;
		uniform float _FogLevel;
		uniform float _MaskClipValue = 0.5;


		float4 Tex2DFiltering587( float4 texel , sampler2D tex , float2 uv )
		{
			uv = uv*float2(texel.z,texel.w);
			// scaler 
			//float scaler=256;
			float2 resize= float2(texel.x,texel.y);
			float2 pixXY= floor(uv);
			float2 offset= uv-pixXY;
			float4 c1=tex2D(tex,resize*(pixXY));
			float4 c2=tex2D(tex,resize*(pixXY+float2(ceil(offset.x),0)));
			float4 c3=tex2D(tex,resize*(pixXY+float2(0,ceil(offset.y))));
			float4 c4=tex2D(tex,resize*(pixXY+ceil(offset)));
			float4 c5=lerp(c1,c2,offset.x);
			float4 c6=lerp(c3,c4,offset.x);
			return lerp(c5,c6,offset.y);
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			float4 temp_output_348_0 = ( _sunColor * clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_DayRange - _setRange)) , 0.0 , 1.0 ) );
			float3 normalizeResult132 = normalize( i.viewDir );
			float3 viewDirNormalized487 = normalizeResult132;
			float dotResult309 = dot( ase_worldlightDir , -viewDirNormalized487 );
			float4 temp_output_335_0 = lerp( lerp( _SunSetSky , _DaySky , clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_DayRange - _setRange)) , 0.0 , 1.0 ) ) , _NightSky , clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_nightRange - _setRange)) , 0.0 , 1.0 ) );
			float3 appendResult442 = float3( _MoonPosition.x , _MoonPosition.y , _MoonPosition.z );
			float3 appendResult415 = float3( appendResult442.x , ( ( appendResult442.y + 0.5 ) * 2.0 ) , appendResult442.z );
			float3 normalizeResult417 = normalize( appendResult415 );
			float2 appendResult425 = float2( ( normalizeResult417.x * _moonScale ) , ( normalizeResult417.z * _moonScale ) );
			float3 appendResult414 = float3( i.viewDir.x , ( ( i.viewDir.y + -0.5 ) * 2.0 ) , i.viewDir.z );
			float3 normalizeResult416 = normalize( appendResult414 );
			float2 componentMask418 = normalizeResult416.xz;
			float2 temp_output_422_0 = ( componentMask418 * _moonScale );
			float4 tex2DNode434 = tex2D( _Moon, clamp( ( appendResult425 + ( temp_output_422_0 + float2( 0.5,0.5 ) ) ) , float2( 0,0 ) , float2( 1,1 ) ) );
			float cos431 = cos( _BGRotate );
			float sin431 = sin( _BGRotate );
			float2 rotator431 = mul(( ( componentMask418 * _BGscale ) + float2( 0.5,0.5 ) ) - float2( 0.5,0.5 ), float2x2(cos431,-sin431,sin431,cos431)) + float2( 0.5,0.5 );
			float4 temp_output_329_0 = lerp( _SunSetAtmosphere , _DayAtmosphere , clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_DayRange - _setRange)) , 0.0 , 1.0 ) );
			float4 temp_output_336_0 = lerp( temp_output_329_0 , _NightAtmosphere , clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_nightRange - _setRange)) , 0.0 , 1.0 ) );
			float4 SkyOnly342 = ( ( temp_output_348_0 * clamp( (0.0 + (dotResult309 - ( _sunMax - _sunMin )) * (1.0 - 0.0) / (_sunMax - ( _sunMax - _sunMin ))) , 0.0 , 1.0 ) * _sunColor.a ) + lerp( lerp( ( temp_output_335_0 + ( tex2DNode434 * 0.1 * tex2DNode434.a ) ) , lerp( tex2D( _StarField, rotator431 ) , tex2DNode434 , tex2DNode434.a ) , clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_nightRange - _setRange)) , 0.0 , 1.0 ) ) , temp_output_336_0 , ( 1.0 - smoothstep( _AtmosphereStart , _AtmosphereEnd , -viewDirNormalized487.y ) ) ) + ( pow( (0.0 + (dotResult309 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , ( 1.0 / max( ( _SunGlow * ( 1.0 - clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_DayRange - _setRange)) , 0.0 , 1.0 ) ) ) , 0.0001 ) ) ) * temp_output_329_0 * _sunColor.a ) );
			float4 BaseColor345 = temp_output_336_0;
			float SmootGlowMask466 = tex2D( _MoonGlow, clamp( ( ( ( temp_output_422_0 * 0.33 ) + float2( 0.5,0.5 ) ) + ( appendResult425 * 0.33 ) ) , float2( 0,0 ) , float2( 1,1 ) ) ).r;
			float4 texel587 = _BaseCloud_TexelSize;
			sampler2D tex587 = _BaseCloud;
			float3 appendResult116 = float3( normalizeResult132.x , normalizeResult132.y , normalizeResult132.z );
			float3 normalizeResult47 = normalize( appendResult116 );
			float2 appendResult86_g42 = float2( normalizeResult47.x , normalizeResult47.z );
			float cos87_g42 = cos( _CloudsRotation );
			float sin87_g42 = sin( _CloudsRotation );
			float2 rotator87_g42 = mul(appendResult86_g42 - float2( 0,0 ), float2x2(cos87_g42,-sin87_g42,sin87_g42,cos87_g42)) + float2( 0,0 );
			float InY62_g42 = normalizeResult47.y;
			float InS62_g42 = ( ( _CloudsScale * 0.0001 ) / max( ( normalizeResult47.y - _DomeCurved ) , 1E-05 ) );
			float InH62_g42 = _DomeCurved;
			float localMyCustomExpression62_g4262_g42 = ( 1/(InS62_g42*InY62_g42-InS62_g42*InH62_g42) );
			float mulTime359 = _Time.y * _timeScale;
			float mulTime514 = _Time.y * _DistortionTime;
			float4 tex2DNode495 = tex2D( _DistortionTexture, ( ( ( ( ( rotator87_g42 * localMyCustomExpression62_g4262_g42 ) + ( _CloudsPan + mulTime359 ) ) * _DistortionScale ) + _DistortionPan ) + mulTime514 ) );
			float2 temp_output_526_0 = ( ( ( rotator87_g42 * localMyCustomExpression62_g4262_g42 ) + ( _CloudsPan + mulTime359 ) ) + ( tex2DNode495.r * _DistortionMax * (_DistortionMin + (abs( normalizeResult47.y ) - 0.0) * (1.0 - _DistortionMin) / (1.0 - 0.0)) ) );
			float2 uv587 = temp_output_526_0;
			float4 localTex2DFiltering587587 = Tex2DFiltering587( texel587 , tex587 , uv587 );
			float componentMask596 = localTex2DFiltering587587.x;
			float temp_output_4_0_g87 = ( _CloudsDensity + _CloudsThickness );
			float temp_output_3_0_g88 = step( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) , 0.5 );
			float nightControl484 = clamp( (0.0 + (ase_worldlightDir.y - _setRange) * (1.0 - 0.0) / (_nightRange - _setRange)) , 0.0 , 1.0 );
			float4 mySkyColor366 = temp_output_335_0;
			float temp_output_4_0_g121 = ( 0.0 + _CloudsShadowBalance );
			float4 mySunColor349 = temp_output_348_0;
			float2 UV175 = temp_output_526_0;
			float3 appendResult149 = float3( UnpackNormal( tex2D( _normalTexture, UV175 ) ).x , UnpackNormal( tex2D( _normalTexture, UV175 ) ).z , -UnpackNormal( tex2D( _normalTexture, UV175 ) ).y );
			float3 appendResult157 = float3( _normalscale , _normalscale , 1 );
			float3 In0367 = ( appendResult149 * appendResult157 );
			float3 localfixNormal367367 = ( In0367*255/64+(255-64)/64 );
			float3 normalizeResult158 = normalize( localfixNormal367367 );
			float3 appendResult375 = float3( normalizeResult47.x , ( _YScale * normalizeResult47.y ) , normalizeResult47.z );
			float dotResult166 = dot( lerp(normalizeResult158,BlendNormals( normalizeResult158 , appendResult375 ),_normalMapenable) , ase_worldlightDir );
			float temp_output_4_0_g120 = ( _CloudsBrightness + _CloudsContract );
			float ViewDirY453 = normalizeResult132.y;
			float4 temp_output_458_0 = lerp( lerp( SkyOnly342 , lerp( lerp( ( lerp( BaseColor345 , _ExtraLight , ( SmootGlowMask466 * lerp(clamp( ( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) + ( frac( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) ) * 0 ) ) , 0 , 1 ),( ( ( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) * tex2DNode495.r * temp_output_3_0_g88 ) * 2.0 ) + ( ( 1.0 - ( ( ( 1.0 - (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) ) * ( 1.0 - tex2DNode495.r ) ) * 2.0 ) ) * ( 1.0 - temp_output_3_0_g88 ) ) ),_ToggleExtra) * nightControl484 * _ExtraLight.a ) ) * _CloudsTransmission ) , ( mySkyColor366 * _CloudsShadowWeight ) , (0.0 + (clamp( componentMask596 , 0.0 , temp_output_4_0_g121 ) - 0.0) * (1.0 - 0.0) / (temp_output_4_0_g121 - 0.0)) ) , ( ( mySunColor349 * ( lerp(dotResult166,(0.0 + (dotResult166 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)),_remapswitch) + _DotOffset ) ) * (0.0 + (clamp( componentMask596 , _CloudsBrightness , temp_output_4_0_g120 ) - _CloudsBrightness) * (1.0 - 0.0) / (temp_output_4_0_g120 - _CloudsBrightness)) ) , ( lerp(dotResult166,(0.0 + (dotResult166 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)),_remapswitch) + _DotOffset ) ) , lerp(clamp( ( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) + ( frac( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) ) * 0 ) ) , 0 , 1 ),( ( ( (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) * tex2DNode495.r * temp_output_3_0_g88 ) * 2.0 ) + ( ( 1.0 - ( ( ( 1.0 - (0.0 + (clamp( min( componentMask596 , step( normalizeResult47.y , _DomeCurved ) ) , _CloudsDensity , temp_output_4_0_g87 ) - _CloudsDensity) * (1.0 - 0.0) / (temp_output_4_0_g87 - _CloudsDensity)) ) * ( 1.0 - tex2DNode495.r ) ) * 2.0 ) ) * ( 1.0 - temp_output_3_0_g88 ) ) ),_ToggleExtra) ) , lerp( _FogColor , _GroundColor , clamp( (0.0 + (ViewDirY453 - 0.0) * (1.0 - 0.0) / (_GroundLevel - 0.0)) , 0.0 , 1.0 ) ) , clamp( (0.0 + (ViewDirY453 - ( _GroundLevel - _FogLevel )) * (1.0 - 0.0) / (_GroundLevel - ( _GroundLevel - _FogLevel ))) , 0.0 , 1.0 ) );
			o.Emission = temp_output_458_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	//CustomEditor "ASEMaterialInspector"
}
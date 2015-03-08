#version 420 core

//==================================================================================================================|
// Copyright (C) 2014-2015 Daniel L. Watkins
// This file is licensed under the MIT License.
//==================================================================================================================|

in TESOut
{
	vec2 tc;
	vec3 worldCoord;
	vec3 eyeCoord;
	float brightness;
} fsIn;

out vec4 color;

uniform float height;

layout (binding = 2) uniform usamplerBuffer textureLayers;
layout (binding = 3) uniform sampler2DArray terrainTexture;

uniform int terrainSize;
uniform int spanSize;
uniform float spacing;
uniform int heightMapSize;
uniform int textureMapResolution;

int tcms = (heightMapSize-1) * textureMapResolution + 1;
int centerIndex = int(fsIn.tc.x * tcms) + int(fsIn.tc.y * tcms)*tcms;
vec4 parts[9];
vec4 mixes[3];

vec4 texelForIndex(int index)
{
	vec3 pos;
	pos.x = fsIn.tc.x / spanSize * terrainSize;
	pos.y = fsIn.tc.y / spanSize * terrainSize;
	pos.z = texelFetch(textureLayers, index).r;

	return texture(terrainTexture, pos);
}

#define TOP_LEFT		0
#define TOP				1
#define TOP_RIGHT		2
#define LEFT			3
#define CENTER			4
#define RIGHT			5
#define BOTTOM_LEFT		6
#define BOTTOM			7
#define BOTTOM_RIGHT	8


void buildParts()
{
	parts[TOP_LEFT]		= texelForIndex(centerIndex-tcms-1);
	parts[TOP]			= texelForIndex(centerIndex-tcms);
	parts[TOP_RIGHT]	= texelForIndex(centerIndex-tcms+1);

	parts[LEFT]			= texelForIndex(centerIndex-1);
	parts[CENTER]		= texelForIndex(centerIndex);
	parts[RIGHT]		= texelForIndex(centerIndex+1);

	parts[BOTTOM_LEFT]	= texelForIndex(centerIndex+tcms-1);
	parts[BOTTOM]		= texelForIndex(centerIndex+tcms);
	parts[BOTTOM_RIGHT]	= texelForIndex(centerIndex+tcms+1);
}


void computeMixes()
{
	vec2 local = fsIn.tc * float(tcms);
	local.x = local.x - int(local.x);
	local.y = local.y - int(local.y);
	
	float centerIntensity = 0.50;

	vec4 hCenter = mix(mix(parts[LEFT], parts[RIGHT], local.x), parts[CENTER], centerIntensity);
	vec4 vCenter = mix(mix(parts[TOP], parts[BOTTOM], local.y), parts[CENTER], centerIntensity);

	vec4 topBar = mix(mix(parts[TOP_LEFT], parts[TOP_RIGHT], local.x), parts[TOP], centerIntensity);
	vec4 bottomBar = mix(mix(parts[BOTTOM_LEFT], parts[BOTTOM_RIGHT], local.x), parts[BOTTOM], centerIntensity);

	vec4 leftBar = mix(mix(parts[TOP_LEFT], parts[BOTTOM_LEFT], local.y), parts[LEFT], centerIntensity);
	vec4 rightBar = mix(mix(parts[TOP_RIGHT], parts[BOTTOM_RIGHT], local.y), parts[RIGHT], centerIntensity);


	vec4 hSides = mix(topBar, bottomBar, local.y);
	vec4 vSides = mix(leftBar, rightBar, local.x);

	vec4 hTotal = mix(hSides, hCenter, centerIntensity);
	vec4 vTotal = mix(vSides, vCenter, centerIntensity);
	
	color = mix(hTotal, vTotal, 0.5);
}


void main()
{
	buildParts();
	computeMixes();

	const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
	color = mix(black, color, fsIn.brightness);
}
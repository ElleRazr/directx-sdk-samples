//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
}

//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float4 Color : COLOR0;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR )
{
    VS_OUTPUT output = (VS_OUTPUT)0;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    output.Color = Color;
    return output;
}

VS_OUTPUT VS_main(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT)0;

    // Translation
    float3 T = float3(1.0, 0.3, 1.0);
    float4 translatedPos = float4(Pos.xyz + T, 1.0);

    // Scaling
    float3 Scale = float3(0.2, 3.0, 3.0);
    float4 scaledPos = float4(translatedPos.xyz * Scale, 1.0);

    // Rotation around Y-axis
    float angle = 45.0; // Angle in degrees
    float4 rotatedPos;
    float c = cos(angle * 3.14159 / 180.0);
    float s = sin(angle * 3.14159 / 180.0);
    rotatedPos.x = scaledPos.x * c + scaledPos.z * s;
    rotatedPos.y = scaledPos.y;
    rotatedPos.z = -scaledPos.x * s + scaledPos.z * c;
    rotatedPos.w = 1.0;

    output.Pos = mul(rotatedPos, World);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;

    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}

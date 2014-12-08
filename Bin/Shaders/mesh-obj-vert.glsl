#version 420 core

layout (location = 0) in vec4 pos;

uniform mat4 cameraMatrix;
uniform mat4 modelMatrix;

void main()
{
	float scale = 1.5f;
	gl_Position = cameraMatrix * modelMatrix * vec4(pos.x*scale, pos.y*scale, pos.z*scale, pos.w);
}
#version 110
precision highp float;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjMatrix;

attribute vec4 aPosition;
attribute vec4 aNormal;
attribute vec4 aTexCoord;
attribute vec4 aColor;
attribute vec4 aBiTangent;

varying vec4 vPosition;
varying vec4 vNormal;
varying vec4 vTexCoord;
varying vec4 vColor;

varying mat4 vTBNMatrix;
varying vec3 vLightDir;
varying vec3 vEyeVec;

void main(void) {		
	vPosition = vec4((uViewMatrix*uModelMatrix) * aPosition);
	vTexCoord = aTexCoord;	
		
	vNormal = vec4(normalize(aNormal.xyz), aNormal.a);
	vec4 biTangent = (aBiTangent * 2.0 / 255.0) - 1.0;
	biTangent = normalize(biTangent);
	vec3 tangent = biTangent.a * cross(biTangent.xyz, vNormal.xyz);

	vTBNMatrix = mat4(
		vec4(tangent.x, biTangent.x, vNormal.x,0.0),
		vec4(tangent.y, biTangent.y, vNormal.y,0.0),
		vec4(tangent.z, biTangent.z, vNormal.z,0.0),
		vec4(0.0, 0.0, 0.0, 1.0)
        );
	
	vLightDir =  (inverse(uViewMatrix * uModelMatrix) * vec4(0.0,0.0,5.0,1.0)).xyz;
	vEyeVec = vec3((inverse(uViewMatrix * uModelMatrix) * vec4(0.0,0.0,5.0,1.0)).xyz);
	vColor = aColor;	

    gl_Position = uProjMatrix * uViewMatrix * uModelMatrix * aPosition;
}

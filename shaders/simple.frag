#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution.xy;

    vec3 lightCell = vec3(222.0 / 255.0, 227.0 / 255.0, 195.0 / 255.0);
    vec3 blackCell = vec3(7.0 / 255.0, 80.0 / 255.0, 35.0 / 255.0);
    vec3 darkGreenBG = vec3(7.0 / 255.0, 54.0 / 255.0, 35.0 / 255.0);
    vec3 darkGreenBox = vec3(51.0 / 255.0, 80.0 / 255.0, 74.0 / 255.0);
    vec3 deepShadow = vec3(0.0, 15.0 / 255.0, 10.0 / 255.0);
    vec3 softGlow = vec3(240.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);

    vec3 emeraldGreen = vec3(0.0, 100.0 / 255.0, 70.0 / 255.0);
    vec3 midnightGreen = vec3(0.0, 50.0 / 255.0, 40.0 / 255.0);
    vec3 richTeal = vec3(10.0 / 255.0, 60.0 / 255.0, 50.0 / 255.0);
    vec3 luxuryGoldHint = vec3(200.0 / 255.0, 190.0 / 255.0, 140.0 / 255.0);

    // **Background Gradient for Premium Effect**
    float gradientFactor = uv.y * 0.9 + 0.05 * sin(uTime * 0.8 + uv.x * 3.0);
    vec3 baseColor = mix(darkGreenBG, darkGreenBox, gradientFactor);
    baseColor = mix(baseColor, emeraldGreen, 0.2);
    baseColor = mix(baseColor, midnightGreen, 0.15);

    float wave1 = sin(uTime * 2.0 + uv.x * 6.0) * 0.12;
    float wave2 = cos(uTime * 2.5 + uv.y * 5.0) * 0.10;
    float wave3 = sin(uTime * 3.0 + uv.y * 4.0 + uv.x * 2.5) * 0.08;
    float turbulence = sin(uv.x * 10.0 + uTime) * sin(uv.y * 10.0 + uTime * 1.2) * 0.05;
    
    float motion = wave1 + wave2 + wave3 + turbulence;

    vec3 highlight = mix(lightCell, softGlow, uv.y * 0.3);
    highlight = mix(highlight, luxuryGoldHint, 0.15);
    vec3 shadow = mix(deepShadow, midnightGreen, 1.0 - uv.y * 0.6);

    vec3 finalColor = mix(baseColor, highlight, motion * 0.3);
    finalColor = mix(finalColor, shadow, 0.3);
    finalColor = mix(finalColor, richTeal, motion * 0.25);

    fragColor = vec4(finalColor, 1.0);
}

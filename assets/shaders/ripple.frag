#version 300 es
precision highp float;
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2  uResolution;     // 画布尺寸 (w,h)
uniform float uTime;           // 时间 (秒)
uniform float uAmplitudePx;    // 折射幅度
uniform float uThicknessPx;    // 环带厚度
uniform float uSpeedPx;        // 扩散速度
uniform vec3  uRippleColor;    // 涟漪颜色 (RGB)
uniform float uColorIntensity; // 颜色强度
uniform sampler2D uTexture;    // 背景纹理

// 安全 normalize，避免零向量报错
vec2 safeNormalize(vec2 v) {
    float len = length(v);
    if (len < 1e-5) return vec2(0.0, 0.0);
    return v / len;
}

void main() {
    vec2 frag = FlutterFragCoord().xy;
    vec2 center = uResolution * 0.5;

    float dist = length(frag - center);
    float r = uTime * uSpeedPx;

    // 单圈涟漪强度
    float band = 1.0 - smoothstep(0.0, uThicknessPx, abs(dist - r));

    // 衰减
    float maxR = length(uResolution * 0.5);
    float falloff = exp(-3.0 * r / maxR);

    // 修复：当涟漪半径很小时（动画开始或结束），减少中心点效果
    float minRadius = uThicknessPx * 0.5;
    float centerFade = smoothstep(0.0, minRadius, r);
    band *= centerFade;

    // 径向方向 (安全版)
    vec2 dir = safeNormalize(frag - center);

    // 位移
    float disp = uAmplitudePx * band * falloff;
    vec2 sampleFrag = frag + dir * disp;
    vec2 uv = sampleFrag / uResolution;

    // 获取折射后的背景颜色
    vec4 bgColor = texture(uTexture, uv);

    // 计算涟漪的颜色强度
    float rippleStrength = band * falloff;

    // 创建涟漪颜色效果
    vec3 rippleEffect = uRippleColor * rippleStrength * uColorIntensity;

    // 混合背景色和涟漪色
    // 使用加法混合创建发光效果
    vec3 finalColor = bgColor.rgb + rippleEffect;

    // 也可以尝试其他混合模式：
    // vec3 finalColor = mix(bgColor.rgb, uRippleColor, rippleStrength * uColorIntensity); // 线性混合
    // vec3 finalColor = bgColor.rgb * (1.0 + rippleEffect); // 乘法增亮

    fragColor = vec4(finalColor, bgColor.a);
}
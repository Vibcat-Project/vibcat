import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// 水波纹效果组件
class RippleEffect extends StatefulWidget {
  /// 子组件（背景内容）
  final Widget child;

  /// 折射强度（像素）
  final double amplitude;

  /// 环带厚度（像素）
  final double thickness;

  /// 扩散速度（像素/秒）
  final double speed;

  /// 涟漪颜色
  final Color rippleColor;

  /// 颜色强度 (0.0-2.0)
  final double colorIntensity;

  /// 是否启用点击触发
  final bool enableTapToTrigger;

  /// 是否自动开始动画
  final bool autoStart;

  /// 动画持续时间（秒），超过此时间停止动画
  final double duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.amplitude = 10.0,
    this.thickness = 50.0,
    this.speed = 400.0,
    this.rippleColor = const Color(0x00FFFFFF),
    this.colorIntensity = 0.1,
    this.enableTapToTrigger = false,
    this.autoStart = false,
    this.duration = 2.0,
  });

  @override
  State<RippleEffect> createState() => RippleEffectState();
}

class RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _elapsedSinceStart = 0.0; // Ticker 启动以来的时间（秒）
  double _pulseT0 = 0.0; // 涟漪开始时刻（相对 _elapsedSinceStart）
  bool _active = false; // 是否播放中

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((d) {
      final t = d.inMicroseconds / 1e6;
      _elapsedSinceStart = t;

      if (_active) setState(() {}); // 只在活动时刷新帧
    })..start();

    // 根据 autoStart 决定是否自动开始
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerRipple();
      });
    }
  }

  /// 触发涟漪动画
  void _triggerRipple() {
    _pulseT0 = _elapsedSinceStart;
    _active = true;
    setState(() {});
  }

  /// 停止动画
  void _stopRipple() {
    _active = false;
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 只有在动画活跃时才使用 shader，否则直接返回原始 child
    if (!_active) {
      if (widget.enableTapToTrigger) {
        return GestureDetector(onTap: _triggerRipple, child: widget.child);
      }
      return widget.child;
    }

    Widget rippleWidget = ShaderBuilder(
      assetKey: 'assets/shaders/ripple.frag',
      (context, shader, child) {
        return AnimatedSampler((image, size, canvas) {
          // 当前这圈的已进行时间（秒）
          final t = (_elapsedSinceStart - _pulseT0).clamp(0.0, 1000.0);

          // 检查动画是否应该结束
          if (t > widget.duration) {
            // 延迟停止，确保最后一帧渲染完成
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _stopRipple();
            });
          }

          // ---- float 按声明顺序设置 ----
          shader.setFloat(0, size.width); // uResolution.x
          shader.setFloat(1, size.height); // uResolution.y
          shader.setFloat(2, t); // uTime - 修复后的时间
          shader.setFloat(3, widget.amplitude); // uAmplitudePx
          shader.setFloat(4, widget.thickness); // uThicknessPx
          shader.setFloat(5, widget.speed); // uSpeedPx
          shader.setFloat(6, widget.rippleColor.red / 255.0); // uRippleColor.r
          shader.setFloat(
            7,
            widget.rippleColor.green / 255.0,
          ); // uRippleColor.g
          shader.setFloat(8, widget.rippleColor.blue / 255.0); // uRippleColor.b
          shader.setFloat(9, widget.colorIntensity); // uColorIntensity

          shader.setImageSampler(0, image); // uTexture

          final paint = Paint()..shader = shader;
          canvas.drawRect(Offset.zero & size, paint);
        }, child: child!);
      },
      child: widget.child,
    );

    // 根据是否启用点击触发来决定是否包装 GestureDetector
    if (widget.enableTapToTrigger) {
      return GestureDetector(onTap: _triggerRipple, child: rippleWidget);
    }

    return _active ? rippleWidget : widget.child;
  }

  /// 公开方法：手动触发涟漪
  void triggerRipple() {
    _triggerRipple();
  }

  /// 公开方法：停止动画
  void stopRipple() {
    _stopRipple();
  }
}

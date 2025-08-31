import 'dart:ui';

import 'package:flutter/material.dart';

enum SlideDrawerState { open, close }

class SlideDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  final double drawerWidth;
  final Color? childBackgroundColor;
  final Color? drawerBackgroundColor;
  final SlideDrawerController? controller;
  final Function()? onDragStart;

  // 新增：左滑相关参数
  final double leftSwipeMaxDistance; // 左滑最大距离
  final double leftSwipeThreshold; // 触发事件的阈值
  final VoidCallback? onLeftSwipeThresholdTrig; // 到达阈值时的回调
  final VoidCallback? onLeftSwipeThresholdApply; // 到达阈值时，并且手指松开的回调
  final Function(SlideDrawerState)? onSlideDrawerStateChanged;

  const SlideDrawer({
    super.key,
    required this.child,
    required this.drawer,
    this.drawerWidth = 280,
    this.childBackgroundColor,
    this.drawerBackgroundColor,
    this.controller,
    this.onDragStart,
    this.leftSwipeMaxDistance = 100, // 默认左滑最大距离200
    this.leftSwipeThreshold = 100, // 默认阈值100
    this.onLeftSwipeThresholdTrig,
    this.onLeftSwipeThresholdApply,
    this.onSlideDrawerStateChanged,
  });

  @override
  State<SlideDrawer> createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // 新增：左滑回弹动画控制器
  late AnimationController _leftSwipeController;
  late Animation<double> _leftSwipeAnimation;

  double _dragPosition = 0.0;
  double _dragStartPosition = 0.0;
  bool _isDragging = false;

  // 新增：左滑相关状态
  double _leftSwipePosition = 0.0;
  bool _isLeftSwiping = false;
  bool _hasTriggeredThreshold = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 初始化左滑回弹动画控制器
    _leftSwipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _leftSwipeAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _leftSwipeController, curve: Curves.elasticOut),
    );

    widget.controller?._addOpenCloseDrawer(_openDrawer, _closeDrawer);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _leftSwipeController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    widget.onDragStart?.call();

    _isDragging = true;
    _isLeftSwiping = false;
    _hasTriggeredThreshold = false;
    _animationController.stop();
    _leftSwipeController.stop();

    // 记录拖拽开始时的位置
    if (_animationController.value > 0) {
      // 如果当前有动画或已经打开，从当前位置开始
      _dragStartPosition = _animationController.value * widget.drawerWidth;
    } else {
      // 如果完全关闭，从 0 开始
      _dragStartPosition = 0.0;
    }

    _dragPosition = _dragStartPosition;
    _leftSwipePosition = 0.0;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final delta = details.primaryDelta!;

    // 如果drawer已经打开，只处理drawer的拖拽
    if (_animationController.value > 0) {
      _isLeftSwiping = false;
      setState(() {
        _dragPosition += delta;
        _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
      });
      return;
    }

    // drawer完全关闭状态下的手势处理
    if (!_isLeftSwiping && delta > 0) {
      // 右滑打开drawer，如果还没有确定是左滑状态
      setState(() {
        _dragPosition += delta;
        _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
        // 重置左滑状态
        _leftSwipePosition = 0.0;
      });
    } else if (!_isLeftSwiping && delta < 0 && _dragPosition == 0) {
      // 左滑，并且drawer位置为0，并且还未确定是左滑状态
      _isLeftSwiping = true;
      setState(() {
        // 应用阻尼效果
        final dampedDelta = _applyLeftSwipeDamping(delta.abs());
        _leftSwipePosition += dampedDelta;

        // 检查是否到达阈值
        if (!_hasTriggeredThreshold &&
            _leftSwipePosition >= widget.leftSwipeThreshold) {
          _hasTriggeredThreshold = true;
          widget.onLeftSwipeThresholdTrig?.call();
          // 可以添加触觉反馈
          // HapticFeedback.mediumImpact();
        }
      });
    } else if (_isLeftSwiping && delta < 0) {
      // 继续左滑
      setState(() {
        // 应用阻尼效果
        final dampedDelta = _applyLeftSwipeDamping(delta.abs());
        _leftSwipePosition += dampedDelta;

        // 检查是否到达阈值
        if (!_hasTriggeredThreshold &&
            _leftSwipePosition >= widget.leftSwipeThreshold) {
          _hasTriggeredThreshold = true;
          widget.onLeftSwipeThresholdTrig?.call();
          // 可以添加触觉反馈
          // HapticFeedback.mediumImpact();
        }
      });
    } else if (_isLeftSwiping && delta > 0) {
      if (_leftSwipePosition < widget.leftSwipeThreshold) {
        _hasTriggeredThreshold = false;
      }

      // 左滑过程中反向右滑，减少左滑距离而不是切换到drawer
      setState(() {
        _leftSwipePosition -= delta;
        _leftSwipePosition = _leftSwipePosition.clamp(0.0, double.infinity);

        // 如果左滑距离回到0，可以重置状态允许切换到drawer
        if (_leftSwipePosition == 0) {
          _isLeftSwiping = false;
        }
      });
    } else if (!_isLeftSwiping && delta > 0 && _dragPosition > 0) {
      // 继续右滑drawer
      setState(() {
        _dragPosition += delta;
        _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
      });
    } else if (!_isLeftSwiping && delta < 0 && _dragPosition > 0) {
      // drawer打开过程中反向左滑，减少drawer打开距离
      setState(() {
        _dragPosition += delta; // delta本身是负数
        _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    if (_hasTriggeredThreshold) {
      widget.onLeftSwipeThresholdApply?.call();
    }

    _isDragging = false;

    if (_isLeftSwiping) {
      // 左滑回弹
      _leftSwipeAnimation = Tween<double>(begin: _leftSwipePosition, end: 0.0)
          .animate(
            CurvedAnimation(
              parent: _leftSwipeController,
              curve: Curves.elasticOut,
            ),
          );

      _leftSwipeController.reset();
      _leftSwipeController.forward().then((_) {
        setState(() {
          _leftSwipePosition = 0.0;
        });
      });
    } else {
      // 原有的drawer逻辑
      final velocity = details.primaryVelocity ?? 0;
      final shouldOpen =
          _dragPosition > widget.drawerWidth * 0.5 || velocity > 500;

      // 从当前拖拽位置开始动画
      final currentProgress = _dragPosition / widget.drawerWidth;
      _animationController.value = currentProgress;

      if (shouldOpen) {
        _openDrawer();
      } else {
        _closeDrawer();
      }
    }
  }

  void _openDrawer() {
    _animationController.forward().whenComplete(() {
      widget.onSlideDrawerStateChanged?.call(SlideDrawerState.open);
    });
  }

  void _closeDrawer() {
    _animationController.reverse().whenComplete(() {
      widget.onSlideDrawerStateChanged?.call(SlideDrawerState.close);
    });
  }

  double get _progress {
    if (_isDragging && !_isLeftSwiping) {
      return _dragPosition / widget.drawerWidth;
    }

    return _animation.value;
  }

  double get _leftSwipeOffset {
    if (_isLeftSwiping && _isDragging) {
      return _leftSwipePosition;
    }
    return _leftSwipeAnimation.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([_animation, _leftSwipeAnimation]),
        builder: (context, child) {
          final progress = _progress;
          final translateX = progress * widget.drawerWidth;
          final leftSwipeOffset = _leftSwipeOffset;

          return Stack(
            children: [
              Positioned(
                left: translateX - leftSwipeOffset,
                // 加入左滑偏移
                top: 0,
                bottom: 0,
                width: screenWidth,
                child: Container(
                  color: widget.childBackgroundColor,
                  child: widget.child,
                ),
              ),

              if (progress > 0)
                Positioned(
                  left: -widget.drawerWidth + translateX,
                  top: 0,
                  bottom: 0,
                  width: screenWidth + widget.drawerWidth,
                  child: _buildBlurredWidget(
                    child: Opacity(
                      opacity: _mapRange(progress, 0.2, 0.5, 0, 1),
                      child: Container(
                        color: widget.drawerBackgroundColor?.withOpacity(
                          _mapRange(progress, 0.7, 1, 0, 1),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth, child: widget.drawer),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    progress: progress,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBlurredWidget({
    required Widget child,
    required double progress, // 0~1
    double maxBlur = 50.0, // 最大模糊值，可调
    double start = 0.0, // 开始模糊的 progress
    double end = 1, // 结束模糊的 progress
  }) {
    // 把 progress 映射到 [0, 1]
    double t = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    // 计算实际 blur
    double blurAmount = t * maxBlur;

    if (blurAmount <= 0) {
      return child;
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: child,
      ),
    );
  }

  /// 应用左滑阻尼效果
  /// 类似iOS的橡皮筋效果，超过边界时阻力越来越大
  double _applyLeftSwipeDamping(double delta) {
    // 如果在正常范围内，不应用阻尼
    if (_leftSwipePosition < widget.leftSwipeThreshold) {
      final remainingDistance = widget.leftSwipeThreshold - _leftSwipePosition;
      if (delta <= remainingDistance) {
        return delta; // 完全在范围内，不需要阻尼
      }

      // 部分超出边界，对超出部分应用阻尼
      final normalPart = remainingDistance;
      final excessPart = delta - remainingDistance;
      final dampedExcess = _calculateDamping(
        excessPart,
        _leftSwipePosition - widget.leftSwipeThreshold,
      );
      return normalPart + dampedExcess;
    }

    // 完全超出边界，全部应用阻尼
    final overscroll = _leftSwipePosition - widget.leftSwipeThreshold;
    return _calculateDamping(delta, overscroll);
  }

  /// 计算阻尼系数
  /// overscroll: 当前已经超出的距离
  /// delta: 本次要移动的距离
  double _calculateDamping(double delta, double overscroll) {
    // iOS风格的阻尼公式
    // 阻尼系数随着超出距离增加而减小
    const double dampingFactor = 0.3; // 阻尼强度，值越小阻力越大
    const double maxDamping = 100.0; // 最大阻尼距离

    // 计算当前的阻尼系数 (0-1之间)
    final dampingRatio =
        dampingFactor * (1.0 - (overscroll / maxDamping).clamp(0.0, 0.9));

    return delta * dampingRatio;
  }

  double _mapRange(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    if (inMax == inMin) return outMin; // 避免除0
    double t = (value - inMin) / (inMax - inMin);
    t = t.clamp(0.0, 1.0); // 限制在 [0,1]
    return outMin + (outMax - outMin) * t;
  }
}

class SlideDrawerController {
  Function? _openDrawer;
  Function? _closeDrawer;

  void _addOpenCloseDrawer(Function openDrawer, Function closeDrawer) {
    _openDrawer = openDrawer;
    _closeDrawer = closeDrawer;
  }

  void openDrawer() {
    _openDrawer?.call();
  }

  void closeDrawer() {
    _closeDrawer?.call();
  }

  void dispose() {
    _openDrawer = null;
    _closeDrawer = null;
  }
}

// class SlideDrawer extends StatefulWidget {
//   final Widget child;
//   final Widget drawer;
//   final double drawerWidth;
//   final Color? childBackgroundColor;
//   final Color? drawerBackgroundColor;
//   final SlideDrawerController? controller;
//
//   const SlideDrawer({
//     super.key,
//     required this.child,
//     required this.drawer,
//     this.drawerWidth = 280,
//     this.childBackgroundColor,
//     this.drawerBackgroundColor,
//     this.controller,
//   });
//
//   @override
//   State<SlideDrawer> createState() => _SlideDrawerState();
// }
//
// class _SlideDrawerState extends State<SlideDrawer>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   double _dragPosition = 0.0;
//   double _dragStartPosition = 0.0;
//   bool _isDragging = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     widget.controller?._addOpenCloseDrawer(_openDrawer, _closeDrawer);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onHorizontalDragStart(DragStartDetails details) {
//     _isDragging = true;
//     _animationController.stop();
//
//     // 记录拖拽开始时的位置
//     if (_animationController.value > 0) {
//       // 如果当前有动画或已经打开，从当前位置开始
//       _dragStartPosition = _animationController.value * widget.drawerWidth;
//     } else {
//       // 如果完全关闭，从 0 开始
//       _dragStartPosition = 0.0;
//     }
//
//     _dragPosition = _dragStartPosition;
//   }
//
//   void _onHorizontalDragUpdate(DragUpdateDetails details) {
//     if (!_isDragging) return;
//
//     setState(() {
//       _dragPosition += details.primaryDelta!;
//       _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
//     });
//   }
//
//   void _onHorizontalDragEnd(DragEndDetails details) {
//     if (!_isDragging) return;
//
//     _isDragging = false;
//
//     final velocity = details.primaryVelocity ?? 0;
//     final shouldOpen =
//         _dragPosition > widget.drawerWidth * 0.5 || velocity > 500;
//
//     // 从当前拖拽位置开始动画
//     final currentProgress = _dragPosition / widget.drawerWidth;
//     _animationController.value = currentProgress;
//
//     if (shouldOpen) {
//       _openDrawer();
//     } else {
//       _closeDrawer();
//     }
//   }
//
//   void _openDrawer() {
//     _animationController.forward().then((_) {
//       setState(() {
//         _animationController.forward();
//       });
//     });
//   }
//
//   void _closeDrawer() {
//     _animationController.reverse();
//   }
//
//   double get _progress {
//     if (_isDragging) {
//       return _dragPosition / widget.drawerWidth;
//     }
//
//     return _animation.value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return GestureDetector(
//       onHorizontalDragStart: _onHorizontalDragStart,
//       onHorizontalDragUpdate: _onHorizontalDragUpdate,
//       onHorizontalDragEnd: _onHorizontalDragEnd,
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           final progress = _progress;
//           final translateX = progress * widget.drawerWidth;
//
//           return Stack(
//             children: [
//               Positioned(
//                 left: translateX,
//                 top: 0,
//                 bottom: 0,
//                 width: screenWidth,
//                 child: Container(
//                   color: widget.childBackgroundColor,
//                   child: widget.child,
//                 ),
//               ),
//
//               if (progress > 0)
//                 Positioned(
//                   left: -widget.drawerWidth + translateX,
//                   top: 0,
//                   bottom: 0,
//                   width: screenWidth + widget.drawerWidth,
//                   child: _buildBlurredWidget(
//                     child: Opacity(
//                       opacity: _mapRange(progress, 0.2, 0.5, 0, 1),
//                       child: Container(
//                         color: widget.drawerBackgroundColor?.withOpacity(
//                           _mapRange(progress, 0.7, 1, 0, 1),
//                         ),
//                         child: Row(
//                           children: [
//                             SizedBox(width: screenWidth, child: widget.drawer),
//                             Spacer(),
//                           ],
//                         ),
//                       ),
//                     ),
//                     progress: progress,
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBlurredWidget({
//     required Widget child,
//     required double progress, // 0~1
//     double maxBlur = 50.0, // 最大模糊值，可调
//     double start = 0.0, // 开始模糊的 progress
//     double end = 1, // 结束模糊的 progress
//   }) {
//     // 把 progress 映射到 [0, 1]
//     double t = ((progress - start) / (end - start)).clamp(0.0, 1.0);
//     // 计算实际 blur
//     double blurAmount = t * maxBlur;
//
//     if (blurAmount <= 0) {
//       return child;
//     }
//
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
//         child: child,
//       ),
//     );
//   }
//
//   double _mapRange(
//     double value,
//     double inMin,
//     double inMax,
//     double outMin,
//     double outMax,
//   ) {
//     if (inMax == inMin) return outMin; // 避免除0
//     double t = (value - inMin) / (inMax - inMin);
//     t = t.clamp(0.0, 1.0); // 限制在 [0,1]
//     return outMin + (outMax - outMin) * t;
//   }
// }
//
// class SlideDrawerController {
//   Function? _openDrawer;
//   Function? _closeDrawer;
//
//   void _addOpenCloseDrawer(Function openDrawer, Function closeDrawer) {
//     _openDrawer = openDrawer;
//     _closeDrawer = closeDrawer;
//   }
//
//   void openDrawer() {
//     _openDrawer?.call();
//   }
//
//   void closeDrawer() {
//     _closeDrawer?.call();
//   }
//
//   void dispose() {
//     _openDrawer = null;
//     _closeDrawer = null;
//   }
// }

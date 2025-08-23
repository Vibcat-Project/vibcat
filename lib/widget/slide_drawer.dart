import 'dart:ui';

import 'package:flutter/material.dart';

class SlideDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  final double drawerWidth;
  final Color? childBackgroundColor;
  final Color? drawerBackgroundColor;
  final SlideDrawerController? controller;

  const SlideDrawer({
    super.key,
    required this.child,
    required this.drawer,
    this.drawerWidth = 280,
    this.childBackgroundColor,
    this.drawerBackgroundColor,
    this.controller,
  });

  @override
  State<SlideDrawer> createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _dragPosition = 0.0;
  double _dragStartPosition = 0.0;
  bool _isDragging = false;

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

    widget.controller?._addOpenCloseDrawer(_openDrawer, _closeDrawer);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _isDragging = true;
    _animationController.stop();

    // 记录拖拽开始时的位置
    if (_animationController.value > 0) {
      // 如果当前有动画或已经打开，从当前位置开始
      _dragStartPosition = _animationController.value * widget.drawerWidth;
    } else {
      // 如果完全关闭，从 0 开始
      _dragStartPosition = 0.0;
    }

    _dragPosition = _dragStartPosition;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _dragPosition += details.primaryDelta!;
      _dragPosition = _dragPosition.clamp(0.0, widget.drawerWidth);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;

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

  void _openDrawer() {
    _animationController.forward().then((_) {
      setState(() {
        _animationController.forward();
      });
    });
  }

  void _closeDrawer() {
    _animationController.reverse();
  }

  double get _progress {
    if (_isDragging) {
      return _dragPosition / widget.drawerWidth;
    }

    return _animation.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = _progress;
          final translateX = progress * widget.drawerWidth;

          return Stack(
            children: [
              Positioned(
                left: translateX,
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

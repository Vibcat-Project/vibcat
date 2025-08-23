import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';

import '../global/icons.dart';
import '../global/store.dart';
import '../route/route.dart';

class BlurBottomSheet extends StatefulWidget {
  final String title;
  final Widget child;
  final double? maxHeight;
  final bool? ignoreMaxHeight;

  const BlurBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.maxHeight,
    this.ignoreMaxHeight,
  });

  @override
  State<BlurBottomSheet> createState() => _BlurBottomSheetState();

  static Future<dynamic> show<S>(
    String title,
    Widget child, {
    double? maxHeight,
    bool? ignoreMaxHeight,
  }) {
    final future = showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      // 透明，避免默认半透明背景挡住模糊
      barrierColor: AppColor.transparent,
      // 让底部内容自定义
      backgroundColor: AppColor.transparent,
      // 禁用默认动画，使用自定义动画
      transitionAnimationController: null,
      builder: (context) => BlurBottomSheet(
        title: title,
        maxHeight: maxHeight,
        ignoreMaxHeight: ignoreMaxHeight,
        child: child,
      ),
    );

    future.whenComplete(() {
      if (S != dynamic && Get.isRegistered<S>()) {
        Get.delete<S>();
      }
    });

    return future;
  }
}

class _BlurBottomSheetState extends State<BlurBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // 用于监听路由动画的变量
  late Animation<double> _routeAnimation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // 滑动动画：从底部滑入
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // 开始动画
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 获取当前路由的动画控制器
    final route = ModalRoute.of(context);
    if (route?.animation != null) {
      _routeAnimation = route!.animation!;

      // 监听路由动画变化，用于更新blur效果
      _routeAnimation.addListener(_onRouteAnimationChanged);
    }
  }

  void _onRouteAnimationChanged() {
    if (!_isDisposed && mounted) {
      setState(() {
        // 强制重建以更新blur效果
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _routeAnimation.removeListener(_onRouteAnimationChanged);
    _animationController.dispose();
    super.dispose();
  }

  // 计算blur值，结合内部动画和路由动画
  double get _currentBlurValue {
    // 内部动画的blur值 (0 -> 8 -> 0)
    double internalBlur = _animationController.value * 8.0;

    // 路由动画的blur值 (8 -> 0，当路由关闭时)
    double routeBlur = _routeAnimation.value * 8.0;

    // 取两者的最小值，确保blur跟随关闭动画
    return min(internalBlur, routeBlur);
  }

  Widget _titleBar() {
    return SizedBox(
      height: kToolbarHeight,
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 14),
              child: IconButton(
                onPressed: () {
                  _animationController.reverse().then((_) {
                    AppRoute.back();
                  });
                },
                icon: Icon(
                  AppIcon.close,
                  size: 20,
                  color: GlobalStore.themeExt.textHint,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Container(height: 1, color: GlobalStore.themeExt.divider),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _routeAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            // 背景模糊层 - 跟随路由和内部动画
            GestureDetector(
              onTap: () {
                _animationController.reverse().then((_) {
                  AppRoute.back();
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _currentBlurValue,
                  sigmaY: _currentBlurValue,
                ),
                child: Container(color: AppColor.transparent),
              ),
            ),
            // BottomSheet 内容 - 滑动动画
            Transform.translate(
              offset: Offset(0, _slideAnimation.value * screenHeight * 0.5),
              child: Container(
                constraints: widget.ignoreMaxHeight == true
                    ? null
                    : BoxConstraints(
                        maxHeight: widget.maxHeight ?? screenHeight * 0.7,
                      ),
                decoration: BoxDecoration(
                  color: GlobalStore.themeExt.container,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    // 底层柔和大阴影
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.05),
                      offset: const Offset(0, 6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                    // 上层小范围阴影，增加立体感
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.03),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  Get.mediaQuery.padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题栏，固定不动
                    _titleBar(),
                    // 可滚动区域
                    Flexible(
                      child: SingleChildScrollView(
                        // 解决键盘遮挡问题
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vibcat/widget/size_reporting.dart';

class AutoSizedPageView extends StatefulWidget {
  final List<Widget> children;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final double? maxHeight;
  final ScrollPhysics? physics;

  const AutoSizedPageView({
    super.key,
    required this.children,
    this.controller,
    this.onPageChanged,
    this.maxHeight,
    this.physics,
  });

  @override
  State<AutoSizedPageView> createState() => _AutoSizedPageViewState();
}

class _AutoSizedPageViewState extends State<AutoSizedPageView>
    with TickerProviderStateMixin {
  late PageController _controller;
  int _currentPage = 0;
  final Map<int, double> _heights = {};
  double _currentHeight = 200;
  late AnimationController _heightAnimationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PageController();
    _heightAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 200, end: 200).animate(
      CurvedAnimation(
        parent: _heightAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 监听页面滚动来实时更新高度
    _controller.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageScroll);
    _heightAnimationController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (!_controller.hasClients) return;

    final double page = _controller.page ?? _currentPage.toDouble();
    final int currentPageIndex = page.floor();
    final int nextPageIndex = page.ceil();
    final double progress = page - currentPageIndex;

    // 获取当前页和下一页的高度
    final double currentPageHeight = _heights[currentPageIndex] ?? 200;
    final double nextPageHeight = _heights[nextPageIndex] ?? currentPageHeight;

    // 根据滚动进度插值计算高度
    double interpolatedHeight =
        currentPageHeight + (nextPageHeight - currentPageHeight) * progress;

    // 应用最大高度限制
    if (widget.maxHeight != null) {
      interpolatedHeight = interpolatedHeight.clamp(0, widget.maxHeight!);
    }

    if (mounted && (_currentHeight - interpolatedHeight).abs() > 0.1) {
      setState(() {
        _currentHeight = interpolatedHeight;
      });
    }
  }

  void _updateHeight(int pageIndex, Size size) {
    if (!mounted) return;

    // 应用最大高度限制
    double newHeight = size.height;
    if (widget.maxHeight != null) {
      newHeight = newHeight.clamp(0, widget.maxHeight!);
    }

    // setState(() {
    //   _heights[pageIndex] = newHeight;
    //   // 如果是当前页面，立即更新高度
    //   if (pageIndex == _currentPage) {
    //     _currentHeight = newHeight;
    //   }
    // });

    final oldHeight = _heights[pageIndex];
    _heights[pageIndex] = newHeight;

    // 如果是当前页面且高度确实发生了变化，使用动画更新高度
    if (pageIndex == _currentPage &&
        (oldHeight != null && (oldHeight - newHeight).abs() > 0.1)) {
      // 停止之前的动画
      _heightAnimationController.stop();

      // 更新动画的起始和结束值
      _heightAnimation = Tween<double>(begin: _currentHeight, end: newHeight)
          .animate(
            CurvedAnimation(
              parent: _heightAnimationController,
              curve: Curves.easeInOut,
            ),
          );

      // 重置并启动动画
      _heightAnimationController.reset();
      _heightAnimationController.forward().then((_) {
        if (mounted) {
          setState(() {
            _currentHeight = newHeight;
          });
        }
      });
    } else {
      setState(() {
        _heights[pageIndex] = newHeight;
        // 如果是当前页面，立即更新高度
        if (pageIndex == _currentPage) {
          _currentHeight = newHeight;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 应用最大高度限制
    double finalHeight = _currentHeight;
    if (widget.maxHeight != null) {
      finalHeight = finalHeight.clamp(0, widget.maxHeight!);
    }

    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return SizedBox(
          height: finalHeight,
          child: PageView.builder(
            physics: widget.physics,
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              widget.onPageChanged?.call(index);
            },
            itemCount: widget.children.length,
            itemBuilder: (context, index) {
              return OverflowBox(
                minHeight: 0,
                maxHeight: double.infinity,
                alignment: Alignment.topCenter,
                child: SizeReportingWidget(
                  onSizeChange: (size) => _updateHeight(index, size),
                  child: widget.maxHeight == null
                      ? widget.children[index]
                      : ConstrainedBox(
                          // 增加最大高度限制后，同时保证内部 ListView 等可滚动组件可正常使用
                          constraints: BoxConstraints(
                            maxHeight: widget.maxHeight!,
                          ),
                          child: widget.children[index],
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

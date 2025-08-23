import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 改进的 SizeReportingWidget
class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    // 使用 LayoutBuilder 来监听尺寸变化
    return LayoutBuilder(
      builder: (context, constraints) {
        // 在下一帧检查尺寸变化
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _checkSize();
        });

        return NotificationListener<SizeChangedLayoutNotification>(
          onNotification: (notification) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _checkSize();
            });
            return true;
          },
          child: SizeChangedLayoutNotifier(
            child: widget.child,
          ),
        );
      },
    );
  }

  void _checkSize() {
    if (!mounted) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      if (_oldSize == null ||
          (_oldSize!.width != size.width || _oldSize!.height != size.height)) {
        _oldSize = size;
        widget.onSizeChange(size);
      }
    }
  }
}

// class SizeReportingWidget extends StatefulWidget {
//   final Widget child;
//   final ValueChanged<Size> onSizeChange;
//
//   const SizeReportingWidget({
//     super.key,
//     required this.child,
//     required this.onSizeChange,
//   });
//
//   @override
//   State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
// }
//
// class _SizeReportingWidgetState extends State<SizeReportingWidget> {
//   final GlobalKey _key = GlobalKey();
//   Size? _oldSize;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());
//     return Container(key: _key, child: widget.child);
//   }
//
//   void _reportSize() {
//     if (_key.currentContext != null) {
//       final RenderBox renderBox =
//           _key.currentContext!.findRenderObject() as RenderBox;
//       final Size newSize = renderBox.size;
//       if (_oldSize != newSize) {
//         _oldSize = newSize;
//         widget.onSizeChange(newSize);
//       }
//     }
//   }
// }

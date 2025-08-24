import 'package:flutter/widgets.dart';

enum ErrorRetryContentPosition { top, bottom }

class ErrorRetry extends StatelessWidget {
  final Widget loading;
  final Widget error;
  final bool? isError;
  final String? content;
  final double spacing;
  final TextStyle? textStyle;
  final ErrorRetryContentPosition? position;
  final dynamic onTap;

  const ErrorRetry({
    super.key,
    required this.loading,
    required this.error,
    this.isError,
    this.content,
    double? spacing,
    this.textStyle,
    this.position,
    this.onTap,
  }) : spacing = spacing ?? 26;

  List<Widget> _content() => content != null
      ? [
          SizedBox(height: spacing),
          Text(content!, style: textStyle ?? TextStyle()),
        ]
      : [];

  Widget _loading() => isError == true ? error : loading;

  List<Widget> _default() => [_loading(), ..._content()];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (position == ErrorRetryContentPosition.top) ...[
            ...(_default().reversed),
          ] else ...[
            ..._default(),
          ],
        ],
      ),
    );
  }
}

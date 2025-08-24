import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LottieWrap extends StatelessWidget {
  final String name;

  const LottieWrap({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(name, fit: BoxFit.contain, repeat: true);
  }
}

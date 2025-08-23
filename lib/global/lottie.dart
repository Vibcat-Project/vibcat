import 'package:flutter/widgets.dart';

class AppLottie {
  static const path = 'assets/lotties/';

  static const loading = '${path}loading.json';

  static Widget loadingWidget() => const Center(
        child: SizedBox(
          width: 150,
          height: 150,
          // child: LottieWrap(name: loading),
        ),
      );
}

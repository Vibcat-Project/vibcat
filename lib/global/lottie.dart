import 'package:flutter/widgets.dart';

import '../widget/lottie_wrap.dart';

class AppLottie {
  static const path = 'assets/lotties';

  static const loading = '$path/loading.json';
  static const rainbowCat = '$path/rainbowCat.json';

  static Widget loadingWidget() => const Center(
    // w:h = 9:5
    child: SizedBox(width: 180, height: 100, child: LottieWrap(name: loading)),
  );

  static Widget loadingRainbowCatWidget() => const Center(
    child: SizedBox(width: 100, height: 100, child: LottieWrap(name: rainbowCat)),
  );
}

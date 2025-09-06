import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../bean/web_search_args.dart';

part 'headless_browser_web_search.dart';

part 'tavily_web_search.dart';

abstract class WebSearchService<T extends WebSearchArgs> {
  T get args;

  Future<String?> request();
}

class WebSearchServiceFactory {
  static WebSearchService create(WebSearchArgs args) =>
      switch (args) {
        HeadlessBrowserWebSearchArgs a => HeadlessBrowserWebSearchService._(a),
        TavilyWebSearchArgs a => TavilyWebSearchService._(a),
      };
}

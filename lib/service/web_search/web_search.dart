import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:vibcat/enum/web_search_type.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/service/http.dart';
import 'package:vibcat/util/log.dart';
import 'package:vibcat/util/web_content_extractor.dart';

import '../../bean/web_search_args.dart';
import '../../data/bean/web_search_item.dart';

part 'bing_web_search.dart';

part 'tavily_web_search.dart';

typedef OnVisitUrl = void Function(String url);

abstract class WebSearchService<T extends WebSearchArgs> {
  T get args;

  OnVisitUrl? get onVisitUrl;

  final httpClient = IHttpClient.create();

  Future<List<WebSearchItem>> request();
}

class WebSearchServiceFactory {
  static WebSearchService create(
    WebSearchArgs args, {
    OnVisitUrl? onVisitUrl,
  }) => switch (args) {
    BingWebSearchArgs a => BingWebSearchService._(a, onVisitUrl: onVisitUrl),
    TavilyWebSearchArgs a => TavilyWebSearchService._(
      a,
      onVisitUrl: onVisitUrl,
    ),
  };
}

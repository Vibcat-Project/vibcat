import 'package:vibcat/bean/web_search_args.dart';
import 'package:vibcat/enum/web_search_type.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/service/web_search.dart';

import '../../bean/web_search_item.dart';

class WebSearchRepository {
  Future<List<WebSearchItem>> request(
    String kw, {
    WebSearchType? searchType,
    OnVisitUrl? onVisitUrl,
  }) async {
    final type = searchType ?? GlobalStore.config.webSearchType;
    WebSearchArgs args;

    switch (type) {
      case WebSearchType.bing:
        args = BingWebSearchArgs(kw: kw);
        break;
      case WebSearchType.tavily:
        args = TavilyWebSearchArgs(kw: kw);
        break;
    }

    return await WebSearchServiceFactory.create(
      args,
      onVisitUrl: onVisitUrl,
    ).request();
  }
}

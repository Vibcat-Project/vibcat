part of 'web_search.dart';

class TavilyWebSearchService extends WebSearchService<TavilyWebSearchArgs> {
  @override
  final TavilyWebSearchArgs args;
  @override
  final OnVisitUrl? onVisitUrl;

  TavilyWebSearchService._(this.args, {this.onVisitUrl});

  @override
  Future<List<WebSearchItem>> request() async {
    final res = await httpClient.post(
      WebSearchType.tavily.endPoint,
      body: {
        'query': args.kw,
        'auto_parameters': false,
        'topic': 'general',
        'search_depth': 'basic',
        'chunks_per_source': 3,
        'max_results': 5,
        'include_answer': false,
        'include_raw_content': false,
        'include_images': false,
        'include_favicon': true,
      },
      headers: {
        'Authorization': 'Bearer ${GlobalStore.config.webSearchApiKey}',
      },
    );
    if (!res.isSuccess || res.data == null) return [];

    LogUtil.success(jsonEncode(res.data));

    try {
      final List results = res.data['results'] ?? [];
      return results
          .map(
            (e) => WebSearchItem(
              title: e['title'] ?? '',
              url: e['url'] ?? '',
              content: e['content'] ?? '',
            ),
          )
          .take(5)
          .toList();
    } catch (e) {
      LogUtil.error(e.toString());
      return [];
    }
  }
}

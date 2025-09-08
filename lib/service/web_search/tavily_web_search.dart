part of 'web_search.dart';

class TavilyWebSearchService extends WebSearchService<TavilyWebSearchArgs> {
  @override
  final TavilyWebSearchArgs args;
  @override
  final OnVisitUrl? onVisitUrl;

  TavilyWebSearchService._(this.args, {this.onVisitUrl});

  @override
  Future<List<WebSearchItem>> request() {
    throw UnimplementedError();
  }
}

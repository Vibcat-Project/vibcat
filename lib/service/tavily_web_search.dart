part of 'web_search.dart';

class TavilyWebSearchService implements WebSearchService<TavilyWebSearchArgs> {
  @override
  TavilyWebSearchArgs args;

  TavilyWebSearchService._(this.args);

  @override
  Future<String?> request() {
    throw UnimplementedError();
  }
}

sealed class WebSearchArgs {
  String get kw;
}

final class BingWebSearchArgs implements WebSearchArgs {
  @override
  final String kw;

  const BingWebSearchArgs({required this.kw});
}

final class GoogleWebSearchArgs implements WebSearchArgs {
  @override
  final String kw;

  const GoogleWebSearchArgs({required this.kw});
}

final class TavilyWebSearchArgs implements WebSearchArgs {
  @override
  final String kw;

  const TavilyWebSearchArgs({required this.kw});
}

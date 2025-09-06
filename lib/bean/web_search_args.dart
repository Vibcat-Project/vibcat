sealed class WebSearchArgs {}

final class HeadlessBrowserWebSearchArgs implements WebSearchArgs {
  final String url;

  const HeadlessBrowserWebSearchArgs({required this.url});
}

final class TavilyWebSearchArgs implements WebSearchArgs {
  final String kw;

  const TavilyWebSearchArgs({required this.kw});
}

part of 'web_search.dart';

class BingWebSearchService extends WebSearchService<BingWebSearchArgs> {
  @override
  final BingWebSearchArgs args;
  @override
  final OnVisitUrl? onVisitUrl;

  BingWebSearchService._(this.args, {this.onVisitUrl});

  @override
  Future<List<WebSearchItem>> request() async {
    final lang = ui.window.locale.languageCode == 'zh' ? 'zh-Hans' : 'en';
    final endPoint = WebSearchType.bing.endPoint;
    final res = await httpClient.get('$endPoint${args.kw}&setlang=$lang');
    if (!res.isSuccess || res.data == null) return [];

    return await _parseValidUrls(res.data);
  }

  /// 解析 HTML 内容，提取 Bing 搜索结果链接
  Future<List<WebSearchItem>> _parseValidUrls(String htmlContent) async {
    final results = <WebSearchItem>[];

    try {
      // 解析 Bing 搜索结果 HTML
      final Document doc = html_parser.parse(htmlContent);

      // 获取所有搜索结果标题
      final items = doc.querySelectorAll('#b_results h2 a');
      var count = 0;

      for (final node in items) {
        if (count >= 2) break;

        final href = node.attributes['href'];
        if (href == null || href.trim().isEmpty) continue;

        final decodedUrl = _decodeBingUrl(href);

        onVisitUrl?.call(node.text);
        final content = await WebContentExtractor.extractContent(decodedUrl);
        if (content == null || content.trim().isEmpty) continue;

        var contentMd = html2md.convert(content);
        if (contentMd.trim().isEmpty) {
          contentMd = content;
        }

        results.add(
          WebSearchItem(
            title: node.text,
            url: decodedUrl,
            content: contentMd.trim(),
          ),
        );

        count++;
      }
    } catch (e) {
      LogUtil.error('Failed to parse Bing search HTML: $e');
    }

    return results;
  }

  /// 解码 Bing 跳转 URL，提取实际链接
  String _decodeBingUrl(String bingUrl) {
    try {
      final uri = Uri.parse(bingUrl);
      final encodedUrl = uri.queryParameters['u'];

      if (encodedUrl == null || encodedUrl.length < 2) {
        return bingUrl; // 没有 u 参数，直接返回原始链接
      }

      // 去掉前缀 "a1"，再解码 Base64, Add padding if necessary for Base64 decoding
      String paddedBase64 = encodedUrl.substring(2);
      while (paddedBase64.length % 4 != 0) {
        paddedBase64 += '=';
      }

      final decodedBytes = base64Decode(paddedBase64);
      final decodedUrl = utf8.decode(decodedBytes);

      if (decodedUrl.startsWith('http')) {
        return decodedUrl;
      }

      return bingUrl;
    } catch (e) {
      return bingUrl;
    }
  }
}

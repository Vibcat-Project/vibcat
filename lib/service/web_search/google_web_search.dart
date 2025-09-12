part of 'web_search.dart';

class GoogleWebSearchService extends WebSearchService<GoogleWebSearchArgs> {
  @override
  final GoogleWebSearchArgs args;
  @override
  final OnVisitUrl? onVisitUrl;

  GoogleWebSearchService._(this.args, {this.onVisitUrl});

  @override
  Future<List<WebSearchItem>> request() async {
    final langZh = ui.window.locale.languageCode == 'zh';
    final endPoint = WebSearchType.google.endPoint;
    final res = await httpClient.get(
      '$endPoint${args.kw}',
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept-Language': langZh ? 'zh-CN,zh;q=0.9' : 'en-US,en;q=0.9',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        // TODO: 临时测试方案，需要更可靠的方式
        'Cookie': langZh
            ? 'AEC=AVh_V2iIvyVgS_l90hBP6W2C8IPwWw8adxSTEgoj4mBqgEEGuMw5cjH1EA; NID=525=PrOcLBKmgS1RVhMMLgqxF6YxYkpiiI9m7N4LwHRaQK_bS3Yb4RFfgqgOzUx9hgJtB8qJvnU7P2_dQoFzhNoyt8ncsJ1XSSsps6bCAFK0nr5A7SYJxveY-d8kODlL8qq1mHZ1PiJ9LZvp8fLfZIWXUV_hgUjTXGnW-An9HfAzT524n-lny80t2JqQfrkUWyqb8UqZ6sd4G4CbQrnlL9gKxdKdMl2f0cGHnJOWsgugPx4Ch8T1jwUGDCkepoESpG5PnYAp3g; DV=w_4M7wEc5Oof0J-HU_sc0efCruvykxk'
            : 'NID=525=f1f0KF_uUQNYcDz-eR1HFQOKQBVoYgO1isc5xmzjncXry7qpAUHSD_ExxzGahlEvdHcxXHbU6NcJc4zwkMYR5T5BE9DF79PnYqlrjkEWFgSo6y9aFTgT98ruYfNmF39U6WSPRTGFkVCwLBH6YX9a6c4QPLx69w3wgyjTCW0H60ECd-ymSd1YV2shV4BNcU-9bT5l_eyDNzWyab070psZ1KsFHDSDj4DHJZt0Lsys6GMq7N0CmZo2ak5jXVXP7yO3; expires=Sat, 14-Mar-2026 18:19:37 GMT; path=/;',
      },
    );
    if (!res.isSuccess || res.data == null) return [];

    return await _parseValidUrls(res.data);
  }

  /// 解析 HTML 内容，提取 Google 搜索结果链接
  Future<List<WebSearchItem>> _parseValidUrls(String htmlContent) async {
    final results = <WebSearchItem>[];

    try {
      // 解析 Google 搜索结果 HTML
      final Document doc = html_parser.parse(htmlContent);

      // 获取所有搜索结果标题
      final items = doc.querySelectorAll('#search .MjjYud');
      var count = 0;

      for (final node in items) {
        if (count >= 2) break;

        final href = node.querySelector('a')?.attributes['href'];
        final title = node.querySelector('h3')?.text;
        if (href == null || href.trim().isEmpty) continue;

        onVisitUrl?.call(title ?? href);
        final content = await WebContentExtractor.extractContent(href);
        if (content == null || content.trim().isEmpty) continue;

        var contentMd = html2md.convert(content);
        if (contentMd.trim().isEmpty) {
          contentMd = content;
        }

        results.add(
          WebSearchItem(
            title: title ?? '',
            url: href,
            content: contentMd.trim(),
          ),
        );

        count++;
      }
    } catch (e) {
      LogUtil.error('Failed to parse Google search HTML: $e');
    }

    return results;
  }
}

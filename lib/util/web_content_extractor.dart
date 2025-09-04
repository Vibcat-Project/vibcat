import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class WebContentExtractor {
  /// 提取网页/文件内容
  static Future<String?> extractContent(String url) async {
    String? content;
    HeadlessInAppWebView? webView;

    try {
      final completer = Completer<String?>();
      Map<String, String>? responseHeaders;

      webView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onReceivedHttpError: (controller, req, res) {
          completer.completeError(
            "HTTP Error: ${res.statusCode} ${res.reasonPhrase}",
          );
        },
        onNavigationResponse: (controller, navigationResponse) async {
          if (navigationResponse.isForMainFrame) {
            responseHeaders = navigationResponse.response?.headers;
          }
          return NavigationResponseAction.ALLOW;
        },
        onLoadStop: (controller, requestUrl) async {
          try {
            // 获取响应头
            final headers = responseHeaders ?? <String, String>{};
            final contentType = headers['Content-Type']?.toLowerCase() ?? '';

            if (contentType.contains("application/pdf")) {
              // PDF 文件 → 下载并提取文字
              content = await _downloadAndExtractPdf(url);
            } else if (contentType.contains("text/html")) {
              // HTML → 注入 Readability 提取正文
              await controller.injectJavascriptFileFromAsset(
                assetFilePath: 'assets/files/readability.js',
              );
              content = await controller.evaluateJavascript(
                source: """
                (function() {
                  var documentClone = document.cloneNode(true);
                  var reader = new Readability(documentClone);
                  var article = reader.parse();
                  return article ? article.content : document.body.innerText;
                })();
              """,
              );
            } else {
              // 其它文件 → 直接下载并转字符串
              content = await _downloadAsString(url);
            }

            completer.complete(content);
          } catch (e) {
            completer.completeError(e);
          }
        },
      );

      webView.run();

      return await completer.future;
    } finally {
      await webView?.dispose();
    }
  }

  /// 下载 PDF 并提取文字（Syncfusion 版本）
  static Future<String?> _downloadAndExtractPdf(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final PdfDocument document = PdfDocument(inputBytes: response.data!);
      final text = PdfTextExtractor(document).extractText(layoutText: true);

      document.dispose();
      return text;
    } catch (e) {
      return null;
    }
  }

  /// 其它类型 → 下载为字符串
  static Future<String?> _downloadAsString(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }
}

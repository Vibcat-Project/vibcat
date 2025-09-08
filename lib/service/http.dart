import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vibcat/util/log.dart';

/// 通用响应模型
class HttpResponse<T> {
  final int? statusCode;
  final T? data;
  final String? message;
  final dynamic raw;

  HttpResponse({this.statusCode, this.data, this.message, this.raw});

  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

/// 通用 Http 接口
abstract class IHttpClient {
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  });

  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  });

  Future<HttpResponse<T>> request<T>(
    String path, {
    String method,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  });

  factory IHttpClient.create() => DioHttpClient();
}

/// Dio 实现
class DioHttpClient implements IHttpClient {
  late final Dio _dio;

  DioHttpClient({
    String baseUrl = '',
    // Duration connectTimeout = const Duration(seconds: 10),
    // Duration receiveTimeout = const Duration(seconds: 10),
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        // connectTimeout: connectTimeout,
        // receiveTimeout: receiveTimeout,
      ),
    )..interceptors.add(AppLogInterceptor());
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) {
    return request(
      path,
      method: 'GET',
      query: query,
      headers: headers,
      responseType: responseType,
    );
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) {
    return request(
      path,
      method: 'POST',
      body: body,
      query: query,
      headers: headers,
      responseType: responseType,
    );
  }

  @override
  Future<HttpResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          headers: headers,
          responseType: responseType,
        ),
      );

      return HttpResponse<T>(
        statusCode: response.statusCode,
        // 注意：如果是流式返回，这里 data 是 ResponseBody
        data: response.data,
        message: response.statusMessage,
        raw: response,
      );
    } on DioException catch (e) {
      dynamic resData;

      if (e.response?.data is ResponseBody) {
        try {
          resData = await _readResponseBody(e.response!.data.stream);
        } catch (_) {
          resData = null;
        }
      } else {
        resData = e.response?.data;
      }

      return HttpResponse<T>(
        statusCode: e.response?.statusCode,
        data: resData,
        message: e.message,
        raw: e.response,
      );
    } catch (e) {
      return HttpResponse<T>(
        statusCode: null,
        data: null,
        message: e.toString(),
        raw: e,
      );
    }
  }
}

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln("REQUEST[${options.method}] => PATH: ${options.uri}");
    if (options.headers.isNotEmpty) {
      buffer.writeln("Headers: ${options.headers}");
    }
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln("Query: ${options.queryParameters}");
    }
    // if (options.data != null) {
    //   buffer.writeln("Body: ${options.data}");
    // }

    LogUtil.info(buffer.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln(
      "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}",
    );
    // if (response.data != null) {
    //   buffer.writeln("Data: ${response.data}");
    // }

    LogUtil.success(buffer.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final buffer = StringBuffer();
    buffer.writeln(
      "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}",
    );
    buffer.writeln("Message: ${err.message}");

    dynamic resData;
    if (err.response?.data is ResponseBody) {
      try {
        resData = await _readResponseBody(err.response!.data.stream);
      } catch (_) {
        resData = null;
      }
    } else {
      resData = err.response?.data;
    }

    if (resData != null) {
      buffer.writeln("Data: $resData");
    }

    LogUtil.error(buffer.toString());
    super.onError(err, handler);
  }
}

Future<String> _readResponseBody(Stream<Uint8List> stream) async {
  final bytes = <int>[];
  await for (final chunk in stream) {
    bytes.addAll(chunk);
  }
  return utf8.decode(bytes);
}

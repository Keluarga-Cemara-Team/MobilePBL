import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'api_exception.dart';

Future<Map<String, dynamic>?> postJsonPlatform(
  String url,
  Map<String, dynamic> payload, {
  Map<String, String>? headers,
}) async {
  try {
    final client = HttpClient()
      ..connectionTimeout = AppConfig.connectTimeout;
    final uri = Uri.parse(url);
    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    headers?.forEach((k, v) => request.headers.set(k, v));
    request.write(jsonEncode(payload));

    final response = await request.close().timeout(AppConfig.connectTimeout);
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(body) as Map<String, dynamic>;
      debugPrint('ApiClient (IO): Sukses respons dari $url');
      return json;
    } else {
      debugPrint('ApiClient (IO): Server status ${response.statusCode} - $body');
      throw ApiException(
        response.statusCode,
        'Server merespons dengan status ${response.statusCode}',
        details: body,
      );
    }
  } on ApiException {
    rethrow;
  } catch (e) {
    debugPrint('ApiClient (IO): Gagal memanggil API $url: $e');
  }
  return null;
}


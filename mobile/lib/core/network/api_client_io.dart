import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>?> postJsonPlatform(
  String url,
  Map<String, dynamic> payload, {
  Map<String, String>? headers,
}) async {
  try {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);
    final uri = Uri.parse(url);
    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    headers?.forEach((k, v) => request.headers.set(k, v));
    request.write(jsonEncode(payload));

    final response = await request.close().timeout(const Duration(seconds: 4));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      debugPrint('ApiClient (IO): Sukses respons dari $url');
      return json;
    } else {
      debugPrint('ApiClient (IO): Server merespons dengan status ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('ApiClient (IO): Gagal memanggil API $url: $e');
  }
  return null;
}


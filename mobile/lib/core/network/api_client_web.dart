import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>?> postJsonPlatform(
  String url,
  Map<String, dynamic> payload, {
  Map<String, String>? headers,
}) async {
  try {
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    final request = await html.HttpRequest.request(
      url,
      method: 'POST',
      sendData: jsonEncode(payload),
      requestHeaders: requestHeaders,
    );

    if (request.status == 200 || request.status == 201) {
      final text = request.responseText ?? '{}';
      final json = jsonDecode(text) as Map<String, dynamic>;
      debugPrint('ApiClient (Web): Sukses respons dari $url');
      return json;
    } else {
      debugPrint('ApiClient (Web): Server status ${request.status}');
    }
  } catch (e) {
    debugPrint('ApiClient (Web): API tidak terjangkau ($e)');
  }
  return null;
}


import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'api_exception.dart';

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

    final text = request.responseText ?? '{}';
    final statusCode = request.status ?? 500;
    if (statusCode == 200 || statusCode == 201) {
      final json = jsonDecode(text) as Map<String, dynamic>;
      debugPrint('ApiClient (Web): Sukses respons dari $url');
      return json;
    } else {
      debugPrint('ApiClient (Web): Server status $statusCode');
      throw ApiException(
        statusCode,
        'Server merespons dengan status $statusCode',
        details: text,
      );
    }
  } on html.ProgressEvent catch (e) {
    final target = e.target;
    if (target is html.HttpRequest) {
      final status = target.status ?? 0;
      if (status != 0) {
        throw ApiException(
          status,
          'Server merespons dengan status $status',
          details: target.responseText,
        );
      }
    }
    debugPrint('ApiClient (Web): Jaringan/CORS error ($e)');
  } on ApiException {
    rethrow;
  } catch (e) {
    debugPrint('ApiClient (Web): API tidak terjangkau ($e)');
  }
  return null;
}


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Top-level function for background isolate
/// This must be a top-level function.
dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

/// Helper function to run decode in background
Future<dynamic> _parseJson(String text) {
  if (text.isEmpty) {
    return Future.value({});
  }
  return compute(_parseAndDecode, text);
}

/// A Transformer that decodes JSON in a background isolate
/// using Flutter's compute function.
class FlutterComputeTransformer extends DefaultTransformer {
  FlutterComputeTransformer() {
    // Set the callback to use our background parser
    jsonDecodeCallback = _parseJson;
  }
}

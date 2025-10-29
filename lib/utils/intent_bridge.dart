import 'dart:io';
import 'package:flutter/services.dart';

class IntentBridge {
  static const MethodChannel _channel = MethodChannel('app.channel/intent');

  static Future<Map<String, dynamic>> getExtras() async {
    if (!Platform.isAndroid) return {};
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('getIntentExtras');
      return res?.map((k, v) => MapEntry(k.toString(), v)) ?? {};
    } catch (_) {
      return {};
    }
  }
}
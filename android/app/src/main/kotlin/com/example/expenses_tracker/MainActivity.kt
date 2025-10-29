package com.example.expenses_tracker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel/intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getIntentExtras") {
                val extras = intent?.extras
                val map = HashMap<String, Any?>()
                if (extras != null) {
                    for (key in extras.keySet()) {
                        map[key] = extras.get(key)
                    }
                }
                result.success(map)
            } else {
                result.notImplemented()
            }
        }
    }
}

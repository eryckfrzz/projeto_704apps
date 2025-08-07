package com.example.projeto_704apps

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Context

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}

object PluginRegistrant {
    fun registerWith(context: Context) {
        val engine = FlutterEngine(context)
        GeneratedPluginRegistrant.registerWith(engine)
    }
}

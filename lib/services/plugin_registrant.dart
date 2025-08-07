import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void registerPlugins() {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialize os plugins diretamente, se necessário
  FlutterSoundRecorder();
  // getTemporaryDirectory();
  // SharedPreferences.getInstance();
}

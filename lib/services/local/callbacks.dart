import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto_704apps/services/local/audio_analyze_dao_impl.dart';
import 'package:projeto_704apps/services/local/db/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final AudioAnalyzeDaoImpl apiService = AudioAnalyzeDaoImpl();
    final FlutterSoundRecorder recorder = FlutterSoundRecorder();
    await recorder.openRecorder();
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/background_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    try {
      await recorder.startRecorder(toFile: path);
      print('DEBUG WORKMANAGER: Gravação em segundo plano iniciada em: $path');

      Timer? chunkTimer;
      final File audioFile = File(path);

      chunkTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
        if (await audioFile.exists()) {
          try {
            Uint8List audioBytes = await audioFile.readAsBytes();
            print(
              'DEBUG WORKMANAGER: Enviando chunk de ${audioBytes.length} bytes.',
            );
            final response = await apiService.registerAudioAnalysis(
              audioBytes,
              DateTime.now().toString(),
              token: token!,
            );

            if (response != null && response.isHostile) {
              print(
                'DEBUG WORKMANAGER: Áudio hostil detectado em segundo plano!',
              );
            }
          } catch (e) {
            print('ERRO WORKMANAGER: Erro ao ler ou enviar áudio chunk: $e');
          }
        }
      });

      await Future.delayed(Duration(seconds: 60));
      chunkTimer.cancel();
      await recorder.stopRecorder();
      print('DEBUG WORKMANAGER: Gravação em segundo plano finalizada.');

      if (await audioFile.exists()) {
        Uint8List finalAudioBytes = await audioFile.readAsBytes();
        final response = await apiService.registerAudioAnalysis(
          token: token!,
          finalAudioBytes,
          DateTime.now().toString(),
        );
        if (response != null && response.id != null) {
          final dbHelper = DatabaseHelper();
          await dbHelper.insertRecording(path, DateTime.now().toString());
          await dbHelper.updateRecordingId(path, response.id);
        }
      }
      return true;
    } catch (e) {
      print('ERRO WORKMANAGER: Tarefa em segundo plano falhou: $e');
      return false;
    } finally {
      await recorder.closeRecorder();
    }
  });
}

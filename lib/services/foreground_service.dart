import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_speech/google_speech.dart';
import 'package:uuid/uuid.dart';
import '../features/models/incident.dart';
import '../features/models/badword.dart';
import '../services/remote/incident_dao_impl.dart';
import '../services/remote/incident_dao_artifact_impl.dart';
import '../services/remote/badword_dao_impl.dart';

final IncidentDaoImpl _apiService = IncidentDaoImpl();
final IncidentArtifactDaoImpl _artifactService = IncidentArtifactDaoImpl();
final BadwordDaoImpl _badwordService = BadwordDaoImpl();

Future<void> startForegroundService() async {
  await FlutterForegroundTask.startService(
    notificationTitle: 'Monitoramento de áudio ativo',
    notificationText: 'O app está ouvindo e analisando hostilidade.',
    callback: startCallback,
  );
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AudioMonitorTaskHandler());
}

class AudioMonitorTaskHandler extends TaskHandler {
  FlutterSoundRecorder? _recorder;
  bool _isReady = false;
  bool _isRecording = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    WidgetsFlutterBinding.ensureInitialized();

    _recorder = FlutterSoundRecorder();

    try {
      await _recorder!.openRecorder();
      _isReady = true;
      print('[ForegroundService] Gravador aberto com sucesso.');
    } catch (e) {
      print('[ForegroundService] Erro ao abrir gravador: $e');
    }
  }

  Future<void> _processAudio() async {
    if (!_isReady || _isRecording) return;
    _isRecording = true;

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('access_token');
    final googleSpeechApiKey = prefs.getString('google_speech_api_key');

    if (authToken == null || googleSpeechApiKey == null) {
      print('[ForegroundService] Token ou API Key ausentes. Abortando.');
      _isRecording = false;
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _recorder!.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
        numChannels: 1,
        sampleRate: 16000,
      );

      print('[ForegroundService] Gravando áudio...');
      await Future.delayed(const Duration(seconds: 5));

      await _recorder!.stopRecorder();
      print('[ForegroundService] Gravação concluída.');

      final file = File(path);
      if (!await file.exists()) {
        print('[ForegroundService] Arquivo de áudio não encontrado.');
        _isRecording = false;
        return;
      }

      final bytes = await file.readAsBytes();
      final transcription = await _transcribeAudio(bytes, googleSpeechApiKey);
      print('[ForegroundService] Transcrição: $transcription');

      List<Badword> allBadwords = [];
      try {
        allBadwords.addAll(await _badwordService.getBadwordsDefault(token: authToken));
        allBadwords.addAll(await _badwordService.getBadwordsCustom(token: authToken));
      } catch (e) {
        print('[ForegroundService] Erro ao buscar badwords: $e');
      }

      final badword = _checkHostilityInTranscription(transcription, allBadwords);
      if (badword != null) {
        final id = const Uuid().v4();
        final incident = Incident(
          id: id,
          level: 4,
          description: 'Palavra hostil: "${badword.word}"',
          timestamp: DateTime.now(),
          location: 'Desconhecida',
          systemAction: 'Hostilidade registrada.',
          audioTranscription: transcription,
        );

        try {
          final registered = await _apiService.registerIncident(incident, token: authToken);
          if (registered) {
            await _artifactService.registerArtifact(id, file.path, 'audio/wav', token: authToken);
            print('[ForegroundService] Incidente registrado com sucesso.');
          } else {
            print('[ForegroundService] Falha ao registrar incidente.');
          }
        } catch (e) {
          print('[ForegroundService] Erro ao enviar dados: $e');
        }
      } else {
        print('[ForegroundService] Nenhuma palavra hostil detectada.');
      }

      await file.delete();
    } catch (e) {
      print('[ForegroundService] Erro no processamento: $e');
    }

    _isRecording = false;
  }

  Future<String> _transcribeAudio(Uint8List audioBytes, String apiKey) async {
    final speechToText = SpeechToText.viaApiKey(apiKey);
    final response = await speechToText.recognize(
      RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        sampleRateHertz: 16000,
        languageCode: 'pt-BR',
      ),
      audioBytes,
    );
    return response.results.map((r) => r.alternatives.first.transcript).join(' ');
  }

  Badword? _checkHostilityInTranscription(String text, List<Badword> badwords) {
    final lowered = text.toLowerCase();
    for (final bw in badwords) {
      if (lowered.contains(bw.word.toLowerCase())) {
        print('[ForegroundService] Palavra hostil detectada: ${bw.word}');
        return bw;
      }
    }
    return null;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _processAudio();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isForeground) async {
    await _recorder?.closeRecorder();
    print('[ForegroundService] Serviço finalizado.');
  }
}

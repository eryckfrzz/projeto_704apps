import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_speech/google_speech.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:projeto_704apps/features/models/incident.dart';
import 'package:projeto_704apps/features/models/badword.dart';
import 'package:projeto_704apps/services/remote/incident_dao_impl.dart';
import 'package:projeto_704apps/services/remote/incident_dao_artifact_impl.dart';
import 'package:projeto_704apps/services/remote/badword_dao_impl.dart';

final IncidentDaoImpl _apiService = IncidentDaoImpl();
final IncidentArtifactDaoImpl _artifactService = IncidentArtifactDaoImpl();
final BadwordDaoImpl _badwordService = BadwordDaoImpl();

/// Função chamada pelo Workmanager
Future<void> backgroundAudioTask(Map<String, dynamic>? inputData) async {
  print('[WorkManager] backgroundAudioTask iniciado');

  // Recupera dados essenciais
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('access_token');

  // Carrega a chave do Google Speech do assets
  String? googleSpeechApiKey;
  try {
    googleSpeechApiKey = (await rootBundle
            .loadString('assets/google_speech_api_key.txt'))
        .trim();
  } catch (e) {
    print('[WorkManager] Erro ao carregar chave do Google Speech: $e');
    return;
  }

  if (authToken == null || googleSpeechApiKey.isEmpty) {
    print('[WorkManager] Token ou chave do Google Speech ausentes. Abortando.');
    return;
  }

  // Confere permissão de microfone
  if (!await Permission.microphone.isGranted) {
    print('[WorkManager] Permissão de microfone não concedida.');
    return;
  }

  // Grava áudio temporário
  final recorder = FlutterSoundRecorder();
  await recorder.openRecorder();

  try {
    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      numChannels: 1,
      sampleRate: 16000,
    );

    print('[WorkManager] Gravando...');
    await Future.delayed(const Duration(seconds: 5));

    await recorder.stopRecorder();
    print('[WorkManager] Gravação finalizada.');

    final file = File(path);
    if (!await file.exists()) {
      print('[WorkManager] Arquivo de áudio não encontrado.');
      return;
    }

    final bytes = await file.readAsBytes();
    final transcription = await _transcribeAudio(bytes, googleSpeechApiKey);

    print('[WorkManager] Transcrição: $transcription');

    // Busca badwords
    List<Badword> allBadwords = [];
    try {
      allBadwords.addAll(
          await _badwordService.getBadwordsDefault(token: authToken));
      allBadwords.addAll(
          await _badwordService.getBadwordsCustom(token: authToken));
    } catch (e) {
      print('[WorkManager] Erro ao buscar badwords: $e');
    }

    // Verifica hostilidade
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
        final registered =
            await _apiService.registerIncident(incident, token: authToken);
        if (registered) {
          await _artifactService.registerArtifact(
              id, file.path, 'audio/wav',
              token: authToken);
          print('[WorkManager] Incidente registrado com sucesso.');
        } else {
          print('[WorkManager] Falha ao registrar incidente.');
        }
      } catch (e) {
        print('[WorkManager] Erro ao enviar dados: $e');
      }
    } else {
      print('[WorkManager] Nenhuma palavra hostil detectada.');
    }

    await file.delete();
  } catch (e) {
    print('[WorkManager] Erro no processo: $e');
  } finally {
    await recorder.closeRecorder();
  }
}


/// Função auxiliar para transcrever áudio
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

/// Função auxiliar para verificar hostilidade
Badword? _checkHostilityInTranscription(String text, List<Badword> badwords) {
  final lowered = text.toLowerCase();
  for (final bw in badwords) {
    if (lowered.contains(bw.word.toLowerCase())) {
      print('[WorkManager] Palavra hostil detectada: ${bw.word}');
      return bw;
    }
  }
  return null;
}

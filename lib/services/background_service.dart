// lib/services/background_service.dart
import 'dart:async';
import 'dart:ui';
import 'dart:io'; // Para File
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos para incidentes
import 'package:projeto_704apps/features/models/incident.dart'; // Importe o modelo de incidente
import 'package:projeto_704apps/services/remote/incident_dao_impl.dart';
import 'package:projeto_704apps/services/remote/incident_dao_artifact_impl.dart';
import 'package:projeto_704apps/helpers/url.dart';

// Instância global do gravador de áudio
final _audioRecorder = AudioRecorder();
Timer? _audioCaptureTimer; // Timer para controlar a gravação em chunks
String? _currentRecordingPath; // Caminho do arquivo de áudio sendo gravado
bool _isProcessingAudio = false; // Flag para evitar processamento simultâneo

final Url _apiUrl = Url(); // Instância da URL da API

final IncidentDaoImpl _apiService = IncidentDaoImpl();
final IncidentArtifactDaoImpl _artifactService = IncidentArtifactDaoImpl();

Future<void> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null) {
    print('Token de autenticação não encontrado.');
  } else {
    print('Token de autenticação obtido com sucesso.');
  }
}


// Função para ser executada em background
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) async {
    print('Serviço de background: Recebendo comando de parada.');
    await _stopAudioRecording(); // Garante que a gravação pare
    service.stopSelf(); // Para o serviço de background
  });

  // Lógica para iniciar a captura de áudio
  service.on('startRecording').listen((event) async {
    print('Serviço de background: Iniciando gravação de áudio...');
    bool hasPermission = await _audioRecorder.hasPermission();

    if (hasPermission) {
      // Inicia a gravação em chunks
      _startAudioCaptureLoop(service);
    } else {
      print('Serviço de background: Permissão de microfone não concedida.');
      service.invoke('update', {
        'current_date': DateTime.now().toIso8601String(),
        'message': 'Permissão de microfone negada.',
      });
    }
  });

  // Lógica para parar a captura de áudio
  service.on('stopRecording').listen((event) async {
    print('Serviço de background: Parando gravação de áudio...');
    await _stopAudioRecording();
    service.invoke('update', {
      'current_date': DateTime.now().toIso8601String(),
      'message': 'Monitoramento parado.',
    });
  });
}

// Inicia o loop de captura e processamento de áudio
Future<void> _startAudioCaptureLoop(ServiceInstance service) async {
  if (_audioCaptureTimer != null && _audioCaptureTimer!.isActive) {
    print('Loop de captura de áudio já está ativo.');
    return;
  }

  // Define um timer para capturar áudio em chunks (ex: a cada 10 segundos)
  _audioCaptureTimer = Timer.periodic(const Duration(seconds: 10), (
    timer,
  ) async {
    if (_isProcessingAudio) {
      print('Já processando áudio, pulando este ciclo.');
      return;
    }
    _isProcessingAudio = true;

    try {
      if (await _audioRecorder.isRecording()) {
        // Se já estiver gravando, pare a gravação atual para obter o arquivo
        final path = await _audioRecorder.stop();
        if (path != null) {
          print('Chunk de áudio gravado em: $path');
          await _processAudioChunk(path, service);
        }
      }

      // Inicia uma nova gravação para o próximo chunk
      final directory = await getTemporaryDirectory();
      _currentRecordingPath =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
        path: _currentRecordingPath!,
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          numChannels: 1,
          sampleRate: 16000,
        ),
      );
      print('Nova gravação iniciada: $_currentRecordingPath');

      service.invoke('update', {
        'current_date': DateTime.now().toIso8601String(),
        'message': 'Monitorando áudio...',
      });
    } catch (e) {
      print('Erro no loop de captura de áudio: $e');
      service.invoke('update', {
        'current_date': DateTime.now().toIso8601String(),
        'message': 'Erro na captura de áudio.',
      });
    } finally {
      _isProcessingAudio = false;
    }
  });

  // Inicia a primeira gravação imediatamente
  final directory = await getTemporaryDirectory();
  _currentRecordingPath =
      '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  await _audioRecorder.start(
    path: _currentRecordingPath!,
    RecordConfig(
      encoder: AudioEncoder.aacLc,
      numChannels: 1,
      sampleRate: 16000,
    ),
  );
  print('Primeira gravação iniciada: $_currentRecordingPath');
}

// Processa um chunk de áudio gravado
Future<void> _processAudioChunk(
  String audioPath,
  ServiceInstance service,
) async {
  // SIMULAÇÃO: Detecção de palavras hostis
  // Em um cenário real, você enviaria este 'audioPath' para um serviço de Speech-to-Text
  // e depois para um serviço de NLP para análise de sentimentos/detecção de palavras-chave.
  bool containsHostileWords =
      DateTime.now().second % 20 < 10; // Simula detecção a cada 10 segundos

  if (containsHostileWords) {
    print('Palavra hostil detectada no áudio: $audioPath');
    service.invoke('update', {
      'current_date': DateTime.now().toIso8601String(),
      'message': 'Incidente detectado!',
    });

    // 1. Registrar Incidente
    final incidentId = Uuid().v4(); // Gera um ID único para o incidente
    final incident = Incident(
      id: incidentId,
      description: 'Hostilidade detectada em áudio.',
      timestamp: DateTime.now(),
      location:
          'Localização desconhecida (adicionar lógica de localização aqui)',
      date: DateTime.now(),
    );

    bool incidentRegistered = await _apiService.registerIncident(
      incident,
      token: getToken().toString(),
    );

    if (incidentRegistered) {
      print('Incidente registrado com sucesso no backend.');
      // 2. Registrar Artefato (o arquivo de áudio)
      bool artifactRegistered = await _artifactService.registerArtifact(
        incidentId,
        audioPath,
        'audio/m4a', // Tipo de arquivo
        token: getToken().toString(),
      );

      if (artifactRegistered) {
        print('Artefato de áudio enviado com sucesso para o backend.');
      } else {
        print('Falha ao enviar artefato de áudio.');
      }
    } else {
      print('Falha ao registrar incidente no backend.');
    }
  } else {
    print('Nenhuma hostilidade detectada no áudio: $audioPath');
  }

  // Opcional: Excluir o arquivo de áudio após o processamento para economizar espaço
  try {
    final file = File(audioPath);
    if (await file.exists()) {
      await file.delete();
      print('Arquivo de áudio temporário excluído: $audioPath');
    }
  } catch (e) {
    print('Erro ao excluir arquivo de áudio: $e');
  }
}

// Função auxiliar para parar a gravação e cancelar o timer
Future<void> _stopAudioRecording() async {
  _audioCaptureTimer?.cancel(); // Cancela o timer de captura periódica
  _audioCaptureTimer = null; // Zera o timer
  if (await _audioRecorder.isRecording()) {
    final path = await _audioRecorder.stop();
    print('Gravação de áudio parada. Último arquivo salvo em: $path');
    // Se o serviço for parado, o último chunk gravado pode precisar ser processado
    if (path != null) {
      // await _processAudioChunk(path, service); // Opcional: Processar o último chunk ao parar
    }
  }
  _currentRecordingPath = null;
  _isProcessingAudio = false;
}

// Função para inicializar o serviço de background
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode:
          true, // Essencial para acesso ao microfone em background
      autoStart: false,
      initialNotificationTitle: 'Mobility Watch',
      initialNotificationContent: 'Serviço de monitoramento ativo',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(autoStart: false, onForeground: onStart),
  );
}

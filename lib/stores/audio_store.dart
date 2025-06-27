import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/audio.dart';
import 'package:projeto_704apps/services/local/audio_analyze_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'audio_store.g.dart';

class AudioStore = _AudioStore with _$AudioStore;

abstract class _AudioStore with Store {
  @observable
  Audio? audio;

  final AudioAnalyzeDaoImpl audioDeviceDaoImpl = AudioAnalyzeDaoImpl();

  @action
  Future<Audio?> registerAudioAnalysis(
    Uint8List audioData,
    String timeStamp,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    Audio? newAudio = await audioDeviceDaoImpl.registerAudioAnalysis(
      audioData,
      timeStamp,
      token: token!,
    );

    if (newAudio != null) {
      audio = newAudio;
      return newAudio;
    }else {
      print('Erro ao registrar análise de áudio.');
      return null;
    }
  }
}

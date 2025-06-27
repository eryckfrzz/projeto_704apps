import 'dart:typed_data';

import 'package:projeto_704apps/features/models/audio.dart';

abstract class AudioAnalyzeDao {
  Future<Audio?> registerAudioAnalysis(
    Uint8List audioData, String timestamp, {
    required String token,
  });
}

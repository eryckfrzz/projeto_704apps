import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/audio/audio_analyze_dao.dart';
import 'package:projeto_704apps/features/models/audio.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';

class AudioAnalyzeDaoImpl implements AudioAnalyzeDao{

   http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  @override
  Future<Audio?> registerAudioAnalysis(Uint8List audioData, String timestamp, {required String token}) async {
    try {
      final Uri uri = Uri.parse(''); //colocar url
      var request = http.MultipartRequest('POST', uri)
        ..fields['timestamp'] = timestamp
        ..files.add(http.MultipartFile.fromBytes(
          'audio_file',
          audioData,
          filename: 'audio_$timestamp.mp3', 
        ));

      var response = await client.send(request);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(responseBody);
        print('Chunk de áudio enviado com sucesso: $timestamp');
        return Audio.fromjson(data);
      } else {
        print('Erro na API ao enviar áudio: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao enviar chunk de áudio: $e');
      return null;
    }
  }
}
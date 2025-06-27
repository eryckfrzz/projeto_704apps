import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/image/image_analyze_dao.dart';
import 'package:projeto_704apps/features/models/image.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';

http.Client client = InterceptedClient.build(
  interceptors: [LoggerInterceptor()],
);

class ImageAnalyzeDaoImpl implements ImageAnalyzeDao{
  @override
  Future<Image?> registerImageAnalysis(
  List<String> imagePaths,
  String audioTranscriptionId,
  {required String token}
) async {
  try {
    final Uri uri = Uri.parse(''); //colocar url;
    var request = http.MultipartRequest('POST', uri,)
      ..fields['audio_transcription'] = audioTranscriptionId;

    for (var path in imagePaths) {
      request.files.add(await http.MultipartFile.fromPath('image_files', path));
    }

    var response = await client.send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Fotos enviadas com sucesso para a API');
      return Image.fromJson(json.decode(responseBody));
    } else {
      print(
        'Erro na API ao enviar fotos: ${response.statusCode} - $responseBody',
      );
      return null;
    }
  } catch (e) {
    print('Erro ao enviar fotos: $e');
    return null;
  }
}

 
}

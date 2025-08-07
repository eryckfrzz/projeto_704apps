import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/image/image_vehicle_dao.dart';
import 'package:projeto_704apps/features/models/ilist_images.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

Url apiUrl = Url();

class ImageAnalyzeDaoImpl implements ImageAnalyzeDao {
  @override
  Future<ListImages?> registerImageAnalysis(
    int userId,
    List<String> imagePaths, {
    required String token,
  }) async {
    try {
      final Uri uri = Uri.parse('${apiUrl.url}/files-sender/vehicles-user/$userId?field=image_files'); 
      var request = http.MultipartRequest('POST', uri);

      for (var path in imagePaths) {
        request.files.add(
          await http.MultipartFile.fromPath('file', path),
        );
      }

      request.headers['Authorization'] = 'Bearer $token';

      var response = await client.send(request);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Fotos enviadas com sucesso para a API');
        return ListImages.fromJson(json.decode(responseBody));
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
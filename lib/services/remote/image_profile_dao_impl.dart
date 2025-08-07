import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/image/image_profile_dao.dart';
import 'package:projeto_704apps/features/models/image_profile.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

http.Client client = InterceptedClient.build(
  interceptors: [LoggerInterceptor()],
);

Url apiUrl = Url();

class ImageProfileDaoImpl implements ImageProfileDao {
  @override
  Future<ImageProfile?> registerImageProfile(
    int userId,
    String file, {
    required String token,
  }) async {
    try {
      final Uri uri = Uri.parse(
        '${apiUrl.url}/files-sender/profile-image/$userId?field=image',
      );

      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file));

      var streamedResponse = await client.send(request);
      final response = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        print('Imagem de perfil enviada com sucesso!');

        Map<String, dynamic> jsonResponse = json.decode(response);

        return ImageProfile.fromJson(jsonResponse);
        // return ImageProfile.fromJson(json.decode(response));
      } else {
        print(
          'Erro ao enviar imagem de perfil: ${streamedResponse.statusCode} - $response',
        );
        return null;
      }
    } catch (e) {
      print('Erro!');
      print(e);
    }

    return null;
  }
}
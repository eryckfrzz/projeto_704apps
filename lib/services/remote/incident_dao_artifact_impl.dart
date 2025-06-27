import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/incident_artifact_dao.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

class IncidentArtifactDaoImpl implements IncidentArtifact {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  Future<bool> registerArtifact(
    String incidentId,
    String fileName,
    String fileType, {
    required String token,
  }) async {
    try {
      final uri = Uri.parse('${apiUrl.url}/incident-artifact/file');
      var request = http.MultipartRequest('POST', uri);

      request.fields['incident_id'] = incidentId;
      request.fields['file_type'] = fileType;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          fileName,
          filename: fileName.split('/').last,
        ),
      );

      request.headers['Authorization'] = 'Bearer $token';

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(
          'DEBUG DAO: Artefato de incidente ($fileType) enviado com sucesso: $fileName',
        );
        return true;
      } else {
        print(
          'ERRO DAO: Falha ao registrar artefato. Status: ${response.statusCode} - $responseBody',
        );
        return false;
      }
    } catch (e) {
      print('ERRO DAO: Exceção ao registrar artefato: $e');
      return false;
    }
  }
}

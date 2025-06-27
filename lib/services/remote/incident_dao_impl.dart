import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/incident_dao.dart';
import 'package:projeto_704apps/features/models/incident.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

class IncidentDaoImpl implements IncidentDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  Future<bool> registerIncident(
    Incident incident, {
    required String token,
  }) async {
    try {
      String incidentJson = jsonEncode(incident.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/incident'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: incidentJson
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Incidente registrado com sucesso!');
        return true;
      } else {
        print('Erro ao registrar incidente: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }
}

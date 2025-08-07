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
        body: incidentJson,
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

@override
  Future<List<Incident>> getIncidents({required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/incident?page=1&size=40&filter='),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON em um Map (objeto)
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Acessa a lista de incidentes dentro da chave 'data' ou 'incidents'
        // Ajuste 'data' para a chave correta que sua API usa para a lista de incidentes
        final List<dynamic> incidentsJsonList = responseData['incidents'] as List<dynamic>; // OU responseData['incidents']

        List<Incident> incidents = [];
        for (var jsonMap in incidentsJsonList) {
          incidents.add(Incident.fromJson(jsonMap as Map<String, dynamic>));
        }

        print('Incidentes encontrados com sucesso! Total: ${incidents.length}');
        return incidents;
      } else {
        print('Erro ao buscar incidentes: Status Code ${response.statusCode} - ${response.body}');
        return Future.error('Falha ao buscar incidentes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar incidentes: $e');
      return Future.error('Erro ao buscar incidentes: ${e.toString()}');
    }
  }
}

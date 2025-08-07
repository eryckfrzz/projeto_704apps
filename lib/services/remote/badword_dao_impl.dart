import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/models/badword.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

// Certifique-se de que estas variáveis globais não estão causando problemas de escopo
http.Client client = InterceptedClient.build(
  interceptors: [LoggerInterceptor()],
);

Url apiUrl = Url();

class BadwordDaoImpl {
  // Busca badwords padrão
  Future<List<Badword>> getBadwordsDefault({required String token}) async {
    final uri = Uri.parse('${apiUrl.url}/badwords/default');
    print('BadwordDaoImpl: GET ${uri.toString()}');
    try {
      final response = await client.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('BadwordDaoImpl: Badwords padrão recebidas: ${jsonList.length} itens.');
        return jsonList.map((json) => Badword.fromjson(json)).toList();
      } else {
        print('BadwordDaoImpl: Erro ao buscar badwords padrão: Status ${response.statusCode} - Corpo: ${response.body}');
        return [];
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao buscar badwords padrão: $e');
      return [];
    }
  }

  // Busca badwords configuradas por dispositivo/usuário (usando userId como deviceId)
  Future<List<Badword>> getBadwordsConfigured(
      int userId, {required String token}) async { // userId como int
    final uri = Uri.parse('${apiUrl.url}/badwords/configured/$userId');
    print('BadwordDaoImpl: GET ${uri.toString()} (userId: $userId)');
    try {
      final response = await client.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('BadwordDaoImpl: Badwords configuradas recebidas: ${jsonList.length} itens.');
        return jsonList.map((json) => Badword.fromjson(json)).toList();
      } else {
        print('BadwordDaoImpl: Erro ao buscar badwords configuradas: Status ${response.statusCode} - Corpo: ${response.body}');
        return [];
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao buscar badwords configuradas: $e');
      return [];
    }
  }

  // Busca badwords customizadas por usuário
  Future<List<Badword>> getBadwordsCustom({required String token}) async {
    final uri = Uri.parse('${apiUrl.url}/badwords/user/custom');
    print('BadwordDaoImpl: GET ${uri.toString()} (custom)');
    try {
      // Assumindo que a API de custom badwords já filtra pelo usuário do token
      final response = await client.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('BadwordDaoImpl: Badwords customizadas recebidas: ${jsonList.length} itens.');
        return jsonList.map((json) => Badword.fromjson(json)).toList();
      } else {
        print('BadwordDaoImpl: Erro ao buscar badwords customizadas: Status ${response.statusCode} - Corpo: ${response.body}');
        return [];
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao buscar badwords customizadas: $e');
      return [];
    }
  }

  // Registra uma badword customizada
  Future<bool> registerBadwordCustom(Badword badword, {required String token}) async {
    final uri = Uri.parse('${apiUrl.url}/badwords/custom');
    final body = jsonEncode(badword.toJson());
    print('BadwordDaoImpl: POST ${uri.toString()} - Corpo: $body');
    try {
      final response = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('BadwordDaoImpl: Badword customizada registrada com sucesso! Status: ${response.statusCode}');
        return true;
      } else {
        print('BadwordDaoImpl: Erro ao registrar badword customizada: Status ${response.statusCode} - Corpo: ${response.body}');
        return false;
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao registrar badword customizada: $e');
      return false;
    }
  }

  // Atualiza uma badword customizada
  Future<bool> updateBadwordCustom(int userId, String oldWord, Badword updatedBadword, {required String token}) async { // userId como int
    final uri = Uri.parse('${apiUrl.url}/badwords/custom/$userId/$oldWord'); // Exemplo de URL com userId int
    final body = jsonEncode(updatedBadword.toJson());
    print('BadwordDaoImpl: PUT ${uri.toString()} - Corpo: $body');
    try {
      final response = await client.put( // Ou PATCH, dependendo da sua API
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('BadwordDaoImpl: Badword customizada atualizada com sucesso! Status: ${response.statusCode}');
        return true;
      } else {
        print('BadwordDaoImpl: Erro ao atualizar badword customizada: Status ${response.statusCode} - Corpo: ${response.body}');
        return false;
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao atualizar badword customizada: $e');
      return false;
    }
  }

  // Exclui uma badword customizada
  Future<bool> deleteBadwordCustom(int userId, String word, {required String token}) async { // userId como int
    final uri = Uri.parse('${apiUrl.url}/badwords/custom/$userId/$word'); // Exemplo de URL com userId int
    print('BadwordDaoImpl: DELETE ${uri.toString()}');
    try {
      final response = await client.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('BadwordDaoImpl: Badword customizada excluída com sucesso! Status: ${response.statusCode}');
        return true;
      } else {
        print('BadwordDaoImpl: Erro ao excluir badword customizada: Status ${response.statusCode} - Corpo: ${response.body}');
        return false;
      }
    } catch (e) {
      print('BadwordDaoImpl: Exceção ao excluir badword customizada: $e');
      return false;
    }
  }
}
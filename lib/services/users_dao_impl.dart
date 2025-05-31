import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/domain/interfaces/users_dao.dart';
import 'package:projeto_704apps/helpers/url.dart';
import 'package:projeto_704apps/domain/models/user.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';

class UsersDaoImpl implements UsersDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  Future<List<User>> getAllUsers({required String? token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/user?page=1&size=40&filter='),
        headers: {"Authorization": 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<User> users = [];

        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('users')) {
          List<dynamic> listDynamic = responseData['users'];

          listDynamic.forEach((user) {
            users.add(User.fromJson(user));
          });

          print('Usuários pesquisados com sucesso!');

          print(users.length);

          return users;
        } else {
          print(response.statusCode);
          print('Erro ao buscar usuários!');
        }
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return [];
  }

  @override
  Future<User?> register(User user) async {
    try {
      final Map<String, dynamic> userData = user.toJson();
      String jsonUser = jsonEncode(userData);

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/user'),
        headers: {"Content-Type": "application/json"},
        body: jsonUser,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('registro criado com sucesso!');
      } else {
        print('${response.statusCode}');
        print('Erro ao registrar usuário!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return null;
  }

  @override
  getUserById(int id, {required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/user/$id'),
        headers: {"Authorization": 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);

        print('Usuário encontrado com sucesso!');

        print(user);

        return User.fromJson(user);
      } else {}
    } catch (e) {
      print(e);
      print('Erro!');
    }
  }

  @override
  Future<bool> updateUser(User user, int id, {required String token}) async {
    try {
      String jsonUser = json.encode(user.toJson());

      http.Response response = await client.patch(
        Uri.parse('${apiUrl.url}/user/$id'),
        headers: {"Authorization": 'Bearer $token'},
        body: jsonUser,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registro atualizado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao atualizar o registro!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> deleteUser(int id, {required String token}) async {
    try {
      http.Response response = await client.delete(
        Uri.parse('${apiUrl.url}/user/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print('Registro deletado com sucesso!');
        return true;
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> sendPushNotification(int userId, {required String token}) async {
    try {
      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/user/push-notification/$userId'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Notificação enviada para o usuário $userId com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao enviar a notificação!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }
}

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/users_dao.dart';
import 'package:projeto_704apps/helpers/url.dart';
import 'package:projeto_704apps/features/models/user.dart';
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
  Future<User?> register(User user, {required bool userApp}) async {
    try {
      final Map<String, dynamic> userData = user.toJson();

      String jsonUser = jsonEncode(userData);

      http.Response response = await client.post(
        Uri.parse(
          '${apiUrl.url}/user',
        ).replace(queryParameters: {'userApp': userApp.toString()}),
        headers: {"Content-Type": "application/json"},
        body: jsonUser,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('registro criado com sucesso!');

        Map<String, dynamic> userData = json.decode(response.body);
        return User.fromJson(userData);
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
  getUserById(int id, {required String token, required bool userApp}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/user/$id').replace(queryParameters: {'userApp': userApp.toString()}),
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

  @override
  Future<bool> addImageProfile(
    int id,
    XFile file, {
    required String token,
  }) async {
    try {
      var uri = Uri.parse('${apiUrl.url}/files-sender/profile-image/$id');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filename: file.name,
          file.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Imagem de perfil enviada!');
        return true;
      } else {
        print('Erro ao enviar a imagem de perdil!');
        print(response.statusCode);
      }
    } catch (e) {
      print('Erro ao registrar imagem de perfil!');
      print(e);
    }
    return false;
  }

  @override
  Future<bool> requestPasswordReset(String email) async {
    try {
      // Use um cliente HTTP sem interceptores de autenticação para esta rota
      // Ou certifique-se que seu LoggerInterceptor não injeta token aqui.
      http.Client publicClient =
          http.Client(); // Cliente sem interceptor de auth

      final Map<String, String> body = {'email': email};
      final String jsonBody = jsonEncode(body);

      http.Response response = await publicClient.post(
        Uri.parse(
          '${apiUrl.url}/auth/forgot-password',
        ), // Endpoint para solicitar reset
        headers: {'Content-type': 'application/json'}, // Apenas Content-type
        body: jsonBody,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // 204 No Content é comum para sucesso sem retorno
        print(
          'Solicitação de recuperação de senha enviada com sucesso para $email!',
        );
        return true;
      } else {
        print(
          'Erro ao solicitar recuperação de senha! Status: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Exceção ao solicitar recuperação de senha: $e');
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      http.Client publicClient = http.Client();

      final Map<String, String> body = {
        'token': token,
        'newPassword': newPassword,
      };
      final String jsonBody = jsonEncode(body);

      http.Response response = await publicClient.post(
        // Ou PATCH/PUT dependendo da sua API
        Uri.parse(
          '${apiUrl.url}/auth/reset-password',
        ), // Endpoint para redefinir senha
        headers: {'Content-type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Senha redefinida com sucesso!');
        return true;
      } else {
        print(
          'Erro ao redefinir senha! Status: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Exceção ao redefinir senha: $e');
      return false;
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/login_dao.dart';
import 'package:projeto_704apps/helpers/url.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDaoImpl implements LoginDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  Future<bool> login({required String email, required String password}) async {
    try {
      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/auth/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login realizado com sucesso!');
        saveUserInfo(response.body);
        return true;
      } else {
        print('${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> getProfile() async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/auth/profile'),
      );

      if (response.statusCode == 200) {
        print('Perfil encontrado com sucesso!');

        return true;
      } else {
        print('Erro ao buscar perfil!');
        print('${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  saveUserInfo(String body) async {
    Map<String, dynamic> userInfo = json.decode(body);

    String token = userInfo['access_token'];

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('access_token', token);

    String? tokenSalvo = prefs.getString('access_token');

    print(tokenSalvo);
  }

  // @override
  // register({required String email, required String password}) async {
  //   try {
  //     http.Response response = await client.post(Uri.parse(url));
  //   } catch (e) {}
  // }
}

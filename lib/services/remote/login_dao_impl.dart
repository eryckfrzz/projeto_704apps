import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/login_dao.dart';
import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/helpers/url.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDaoImpl implements LoginDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/auth/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login realizado com sucesso!');
        final Map<String, dynamic> responseData = json.decode(response.body);

        await saveUserInfo(
          json.encode(responseData),
        ); // Salva o token após o sucesso

        final User loggedInUser = User.fromJson(responseData);
        
        if (loggedInUser.id != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', loggedInUser.id!);
          print('User ID salvo no SharedPreferences: ${loggedInUser.id}');
        } else {
          print('Aviso: O ID do usuário retornado pela API é nulo.');
        }

        return loggedInUser;
      } else {
        print('${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return null;
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
  // Future<bool> register({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   try {
  //     http.Response response = await client.post(
  //       Uri.parse('${apiUrl.url}/user'),
  //       body: {'name': name, 'email': email, 'password': password},
  //     );
  //     if (response.statusCode == 201 || response.statusCode == 201) {
  //       print('Cadastro realizado com sucesso!');

  //       Map<String, dynamic> userData = json.decode(response.body);
  //       final User jsonUser = User.fromJson(userData);
  //       saveUserInfo(response.body);

  //       return true;
  //     }
  //   } catch (e) {
  //     print('Falha ao cadastrar usuário!');
  //     print(e);
  //   }

  //   return false;
  // }
}

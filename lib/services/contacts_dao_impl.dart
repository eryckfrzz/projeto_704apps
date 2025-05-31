import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/domain/interfaces/contact_dao.dart';
import 'package:projeto_704apps/domain/models/contact.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

class ContactsDaoImpl implements ContactDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  getContactById(int id, {required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/contacts/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> contactData = json.decode(response.body);

        print('Contato encontrado com sucesso!');

        return Contact.fromJson(contactData);
      } else {
        print(response.statusCode);
        print('Erro ao pesquisar contato!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }
  }

  @override
  Future<List<Contact>> getContacts({required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/contacts'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<Contact> contacts = [];
        List<dynamic> contactList = json.decode(response.body);

        for (var jsonMap in contactList) {
          contacts.add(Contact.fromJson(jsonMap));
        }

        print('Contatos encontrados com sucesso!');

        return contacts;
      } else {
        print(response.statusCode);
        print('Erro ao pesquisar contatos!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return [];
  }

  @override
  Future<Contact?> registerContact(Contact contact, {required String token}) async {
    try {
      String jsonUser = jsonEncode(contact.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/contacts'),
        headers: {'Authorization': 'Bearer $token','Content-type': 'application/json', },
        body: jsonUser,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Contato registrado com sucesso!');
       
      } else {
        print(response.statusCode);
        print('Erro ao registrar contato!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }
    return null;
   
  }

  @override
  Future<bool> updateContact(
    Contact contact,
    int id, {
    required String token,
  }) async {
    try {
      String jsonContact = json.encode(contact.toJson());

      http.Response response = await client.patch(
        Uri.parse('${apiUrl.url}/contacts/${id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
        body: jsonContact,
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        print('Contato atualizado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao atualizar contato!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }
}

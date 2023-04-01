import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../config.dart';
import '../model/clients_model.dart';

class APIClientsService {
  static var client = http.Client();
  static Future<List<ClientsModel>?> getClients() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.clientsAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return clientsFromJson(data);

      //return true;
    } else {
      return null;
    }
  }

  Future<http.Response> create(ClientsModel model) async {
    return http.post(
      Uri.parse('http://localhost:8080/client'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "cpf": model.cpf.toString(),
        "name": model.name.toString(),
        "sobrenome": model.sobrenome.toString(),
      }),
    );
  }

  Future<http.Response> delete(ClientsModel model) async {
    final http.Response response = await http.delete(
      Uri.parse('http://localhost:8080/client/${model.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 204) {
      print("Deleted");
    } else {
      print(response);
      throw "Cliente nao pode ser excluido porque tem registros";
    }

    return response;
  }

  Future<http.Response> update(ClientsModel model) async {
    return http.put(
      Uri.parse('http://localhost:8080/client'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': model.id.toString(),
        "cpf": model.cpf.toString(),
        "name": model.name.toString(),
        "sobrenome": model.sobrenome.toString(),
      }),
    );
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/Request_model.dart';


class APIRequestService {
  Future<http.Response> create(List<RequestModel> models) async {
    return http.post(
      Uri.parse('http://localhost:8080/request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(models.map((model) => <String, String>{
        "id": model.id.toString(),
        "id_product": model.id_product.toString(),
        "data": model.data.toString(),
        "id_client": model.id_client.toString(),
        "qtd": model.qtd.toString(),
      }).toList()),
    );
  }

  Future<List<RequestModel>> getRequestsByClientId(int clientId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/request/$clientId'),
    );

    print(response);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<RequestModel>((json) => RequestModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }
}


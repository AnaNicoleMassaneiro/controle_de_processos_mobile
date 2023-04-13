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

  static Future<List<RequestModel>> getRequestsByClientId(int clientId) async {
    final response =
    await http.get(Uri.parse('http://localhost:8080/request/searchIdClient/$clientId'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> requestsData = data[0];

      List<RequestModel> requests = [];
      for (var requestData in requestsData) {
        RequestModel request = RequestModel(
          desc: requestData[0],
          name: requestData[1],
          sellerName: requestData[2],
          cpf: requestData[3],
          qtd: int.parse(requestData[4]),
        );
        requests.add(request);
      }

      return requests;
    } else {
      throw Exception('Failed to load requests');
    }
  }


}


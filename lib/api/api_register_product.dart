import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../config.dart';
import '../model/product_model.dart';

class apiRegister {
  Future<http.Response> create(ProductModel model) async {
    return http.post(
      Uri.parse('http://localhost:8080/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'descricao': model.descricao.toString(),
      }),
    );
  }

  Future<http.Response> delete(ProductModel model) async {
    final http.Response response = await http.delete(
      Uri.parse('http://localhost:8080/product/${model.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 204) {
      print("Deleted");
    } else {
      throw "Sorry! Unable to delete this post.";
    }

    return response;
  }

  Future<http.Response> update(ProductModel model) async {
    return http.put(
      Uri.parse('http://localhost:8080/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'descricao': model.descricao.toString(),
        'id': model.id.toString(),
      }),
    );
  }

}

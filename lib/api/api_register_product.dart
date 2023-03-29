import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/product_model.dart';

class apiRegister {
  Future<http.Response> create(ProductModel model) async {
    var api = Config.apiURL;

    var productURL = Uri.parse('localhost:8080/product');

    //return http.post(
    //  productURL,
    //  headers: <String, String>{
    //    'Content-Type': 'application/json;charset=UTF-8',
    //  },
    //  body: jsonEncode(<String, dynamic>{
      //    "descricao": model.descricao.toString(),
    //  }),
    // );

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
}

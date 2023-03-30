import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../config.dart';
import '../model/product_model.dart';

class APIService {
  static var client = http.Client();
  static Future<List<ProductModel>?> getProducts() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.productsAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return productsFromJson(data);

      //return true;
    } else {
      return null;
    }
  }
}
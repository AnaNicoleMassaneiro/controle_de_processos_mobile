import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/Request_model.dart';


class APIRequestService {
  Future<http.Response> create(RequestModel model) async {
    return http.post(
      Uri.parse('http://localhost:8080/request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        //"cpf": model.cpf.toString()
      }),
    );
  }
}


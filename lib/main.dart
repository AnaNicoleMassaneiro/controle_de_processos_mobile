import 'package:controle_de_processos_mobile/pages/clients/clients_add_edit.dart';
import 'package:controle_de_processos_mobile/pages/clients/clients_list.dart';
import 'package:controle_de_processos_mobile/pages/products/product_add_edit.dart';
import 'package:controle_de_processos_mobile/pages/products/product_list.dart';
import 'package:controle_de_processos_mobile/pages/request/novo_pedido.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const ProductsList(),
        '/add-product': (context) => const ProductAddEdit(),
        '/edit-product': (context) => const ProductAddEdit(),
        '/list-clients': (context) => const ClientsList(),
        '/add-clients': (context) => const ClientAddEdit(),
        '/edit-clients': (context) => const ClientAddEdit(),
        '/novo-pedido': (context) => NewOrderScreen(),
      },

    );
  }


}


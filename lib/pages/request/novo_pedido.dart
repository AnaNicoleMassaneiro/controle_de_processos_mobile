import 'package:flutter/material.dart';
import '../../api/api_register_product.dart';
import '../../model/product_model.dart';

class NovoPedido extends StatefulWidget {
  @override
  _NovoPedidoState createState() => _NovoPedidoState();
}

class _NovoPedidoState extends State<NovoPedido> {
  int _indiceAtual = 2;
  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  int? _selectedProductQuantity;
  late String _cpfCliente;
  List<String> _produtosSelecionados = [];
  int _quantidade = 1;
  final List<String> _produtosDisponiveis = [];

  final _cpfController = TextEditingController();
  final _quantidadeController = TextEditingController();

  @override
  void dispose() {
    _cpfController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    switch(index){
      case 1:
        Navigator.pushNamed(context, "/list-clients");
        break;
    }
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Pedido'),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CPF do cliente:'),
                TextField(
                  controller: _cpfController,
                  onChanged: (value) {
                    setState(() {
                      _cpfCliente = value;
                    });
                  },
                ),
                SizedBox(height: 5.0),
                Text('Produtos selecionados:'),
                Container(
                  height: 20.0, // altura específica
                  child: ListView.builder(
                    itemCount: _produtosSelecionados.length,
                    itemBuilder: (context, index) {
                      final produto = _produtosSelecionados[index];
                      return ListTile(
                        title: Text(produto),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _produtosSelecionados.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Text('Adicionar produto:'),
                Container(
                  child: SingleChildScrollView(
                    child: FutureBuilder<List<ProductModel>?>(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _products = snapshot.data!;
                        return buildDropdownButton();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao carregar produtos: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),),
                ),
                SizedBox(height: 16.0),
                Text('Quantidade:'),
                TextField(
                  controller: _quantidadeController,
                  onChanged: (value) {
                    setState(() {
                      _quantidade = int.parse(value);
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    child: Text('Salvar'),
                    onPressed: () {
                      // salvar o pedido
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              label: "Produtos"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Clientes"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: "Pedidos"
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButton() {
    List<ProductModel> uniqueProducts = _products.toSet().toList();
    return DropdownButton<ProductModel>(
      value: _selectedProduct,
      onChanged: (value) {
        setState(() {
          _selectedProduct = value;
        });
      },
      items: uniqueProducts.map<DropdownMenuItem<ProductModel>>((ProductModel product) {
        return DropdownMenuItem<ProductModel>(
          value: product,
          child: Text(product.descricao),
        );
      }).toList(),
    );
  }

  Future<List<ProductModel>?> getProducts() async {
    return apiRegister.getProducts();
  }
}
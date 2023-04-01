import 'package:flutter/material.dart';
import '../../api/api_register_product.dart';

import '../../model/product_model.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _quantityController = TextEditingController();

  late List<ProductModel> _products;
  ProductModel? _selectedProduct;
  int? _selectedProductQuantity;

  Future<List<ProductModel>?> _getProducts() async {
    return apiRegister.getProducts();
  }

  @override
  void initState() {
    super.initState();
    _getProducts().then((products) {
      setState(() {
        _products = products!;
      });
    });
  }

  Widget _buildProductDropdownButton() {
    return DropdownButton<ProductModel>(
      isExpanded: true,
      isDense: true,
      value: _selectedProduct,
      hint: Text('Selecione um produto'),
      onChanged: (ProductModel? value) {
        setState(() {
          _selectedProduct = value;
          _selectedProductQuantity = null;
        });
      },
      items: _products.map((product) {
        return DropdownMenuItem<ProductModel>(
          value: product,
          child: Text(
            product.descricao,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  void _handleAddProduct() {
    if (_selectedProduct != null && _selectedProductQuantity != null) {
      // Implementar a lógica para adicionar o produto ao pedido do cliente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Pedido'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CPF do Cliente',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    // Implementar a validação do CPF
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _buildProductDropdownButton(),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantidade',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    // Implementar a validação da quantidade
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedProductQuantity = int.tryParse(value);
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleAddProduct();
                    }
                  },
                  child: Text('Adicionar Produto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

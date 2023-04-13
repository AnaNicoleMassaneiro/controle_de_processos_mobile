import 'package:controle_de_processos_mobile/api/clients_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../api/api_register_product.dart';

import '../../api/request_service.dart';
import '../../components/bottom_navigation.dart';
import '../../model/Request_model.dart';
import '../../model/product_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _quantityController = TextEditingController();
  List<RequestModel> _selectedProducts = [];
  int _selectedIndex = 2;
  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  get id => null;

  get desc => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List<ProductModel> _products = [];
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

  void onTabTapped(int index) {
    switch(index){
      case 1:
        Navigator.pushNamed(context, "/list-clients");
        break;
    }
    setState(() {
     // _indiceAtual = index;
    });
  }

  Widget _buildProductDropdownButton() {
    return DropdownButton<ProductModel>(
      isExpanded: true,
      isDense: true,
      value: _selectedProduct,
      hint: const Text('Selecione um produto'),
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

  Future<void> _handleAddProduct() async {
    if (_selectedProduct == null || _selectedProductQuantity == null) {
      return;
    }
    final cleanValue = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');

    var idClient = await APIClientsService.getClientsById(cleanValue);
    ProductModel? selectedProduct = _selectedProduct;

    List<RequestModel> selectedProducts = [];

    selectedProducts.add(RequestModel(
      desc: selectedProduct?.descricao ?? '',
      id_client: idClient?.id,
      qtd: int.parse(_quantityController.text),
      id_product: selectedProduct?.id, name: null, sellerName: null, cpf: null,
    ));

    APIRequestService apiService = APIRequestService();
    Response ret = await apiService.create(selectedProducts);

    if(!ret.body.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Produto adicionado com sucesso'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
        title: Text('Erro ao adicionar produto'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CPF do Cliente',
                  ),
                  validator: validateCpf,
                  inputFormatters: [cpfMaskFormatter],
                ),
                const SizedBox(height: 16.0),
                _buildProductDropdownButton(),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleAddProduct();
                    }
                  },
                  child: const Text('Adicionar Produto'),
                ),
                ElevatedButton(
                  onPressed: _handleShowOrders,
                  child: Text('Mostrar Pedidos'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );

  }

  void _handleShowOrders() async {
    final cleanValue = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    var idClient = await APIClientsService.getClientsById(cleanValue);
    if (idClient != null) {
      List<RequestModel> requests = [];
      try {
        requests = await APIRequestService.getRequestsByClientId(idClient.id ?? 0);
      } catch (e) {
        print('Erro ao carregar pedidos do cliente: $e');
      }

      if (requests.isNotEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Pedidos do Cliente'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  RequestModel request = requests[index];
                  return ListTile(
                    title: Text(request.desc ?? ''),
                    subtitle: Text('Quantidade: ${request.qtd}'),
                  );
                },
              ),
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Erro'),
            content: Text('Cliente não possui pedidos'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
  String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanValue.length != 11) {
      return 'CPF inválido';
    }

    return null;
  }



}

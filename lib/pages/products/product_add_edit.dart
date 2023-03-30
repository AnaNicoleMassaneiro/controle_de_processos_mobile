// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../api/api_register_product.dart';
import '../../config.dart';
import '../../model/product_model.dart';

class ProductAddEdit extends StatefulWidget {
  const ProductAddEdit({Key? key}) : super(key: key);

  @override
  _ProductAddEditState createState() => _ProductAddEditState();
}

class _ProductAddEditState extends State<ProductAddEdit> {
  ProductModel? productModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<Object> images = [];
  bool isEditMode = false;
  bool isImageSelected = false;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar Produtos'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: productForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productModel = ProductModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productModel = arguments['model'];
        isEditMode = true;
        setState(() {
          if(isEditMode) {
            myController.text = productModel!.descricao!.toString();
          }
        });
      }
    });
  }

  Widget productForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descrição',
              ),
            ),
          ),
          Center(
            child: FormHelper.submitButton(
              "Salvar",
                  () async {
                if (validateAndSave()) {
                  productModel?.descricao = myController.text;

                  setState(() {
                    isApiCallProcess = true;
                  });

                  var api = apiRegister();
                  Response ret;

                  if(isEditMode) {
                    ret = await api.update(productModel!);
                  } else {
                    ret = await api.create(productModel!);
                  }

                  if (ret.statusCode == 204) {
                    setState(() {
                      isApiCallProcess = false;
                    });

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  } else {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      Config.appName,
                      "Error occur",
                      "OK",
                          () {
                        Navigator.of(context).pop();
                      },
                    );
                  }
                }
              },
              btnColor: HexColor("283B71"),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
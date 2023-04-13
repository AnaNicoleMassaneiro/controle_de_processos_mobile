// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../api/clients_service.dart';
import '../../config.dart';
import '../../model/clients_model.dart';

class ClientAddEdit extends StatefulWidget {
  const ClientAddEdit({Key? key}) : super(key: key);

  @override
  _ClientAddEditState createState() => _ClientAddEditState();
}

class _ClientAddEditState extends State<ClientAddEdit> {
  ClientsModel? clientModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<Object> images = [];
  bool isEditMode = false;
  bool isImageSelected = false;
  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cpfController = TextEditingController();
  final nameController = TextEditingController();
  final sobrenomeController = TextEditingController();

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
            child: clientForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    clientModel = ClientsModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        clientModel = arguments['model'];
        isEditMode = true;
        setState(() {
          if(isEditMode) {
            cpfController.text = clientModel!.cpf!.toString();
            nameController.text = clientModel!.name!.toString();
            sobrenomeController.text = clientModel!.sobrenome!.toString();
          }
        });
      }
    });
  }

  Widget clientForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: cpfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CPF do Cliente',
              ),
              validator: validateCpf,
              inputFormatters: [cpfMaskFormatter],
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Nome',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: sobrenomeController,
              decoration: const InputDecoration(
                hintText: 'Sobrenome',
              ),
            ),
          ),
          Center(
            child: FormHelper.submitButton(
              "Salvar",
                  () async {
                if (validateAndSave()) {
                  clientModel?.name = nameController.text;
                  clientModel?.cpf = cpfController.text;
                  clientModel?.sobrenome = sobrenomeController.text;

                  setState(() {
                    isApiCallProcess = true;
                  });

                  var api = APIClientsService();
                  Response ret;

                  if(isEditMode) {
                    ret = await api.update(clientModel!);
                  } else {
                    ret = await api.create(clientModel!);
                  }

                  if (ret.statusCode == 201 || ret.statusCode == 204) {
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
    nameController.dispose();
    super.dispose();
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

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
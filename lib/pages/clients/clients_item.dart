import 'package:controle_de_processos_mobile/model/clients_model.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ClientsItem extends StatelessWidget {
  final ClientsModel? model;
  final Function? onDelete;

  ClientsItem({
    Key? key,
    this.model,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: cartItem(context),
      ),
    );
  }

  Widget cartItem(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model!.name! + ' ' +  model!.sobrenome!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.edit),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/edit-clients',
                          arguments: {
                            'model': model,
                          },
                        );
                      },
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () {
                        onDelete!(model);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
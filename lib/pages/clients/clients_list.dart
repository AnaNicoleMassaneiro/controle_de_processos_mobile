import 'package:controle_de_processos_mobile/api/clients_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../model/clients_model.dart';
import 'clients_item.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({Key? key}) : super(key: key);

  @override
  _ClientsListState createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  int _indiceAtual = 1;

  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Processos'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        child: loadClients(),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: UniqueKey(),
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

  Widget loadClients() {
    return FutureBuilder(
      future: APIClientsService.getClients(),
      builder: (
          BuildContext context,
          AsyncSnapshot<List<ClientsModel>?> model,
          ) {
        if (model.hasData) {
          return clientsList(model.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void onTabTapped(int index) {
    switch(index){
      case 2:
        Navigator.pushNamed(context, "/novo-pedido");
        break;
    }
    setState(() {
      _indiceAtual = index;
    });
  }

  Widget clientsList(clients) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/add-clients',
                  );
                },
                child: const Text('Adicionar Clientes'),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  return ClientsItem(
                    model: clients[index],
                    onDelete: (ClientsModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });
                      var api = new APIClientsService();

                      api.delete(model).then(
                            (response) {

                        },
                      );

                      setState(() {
                        isApiCallProcess = false;
                      });

                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
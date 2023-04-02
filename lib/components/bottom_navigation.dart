import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        _onItemTapped(context, index);
        onTap(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.production_quantity_limits),
          label: "Produtos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Clientes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: "Pedidos",
        ),
      ],
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/');
        break;
      case 1:
        Navigator.of(context).pushNamed('/list-clients');
        break;
      case 2:
        Navigator.of(context).pushNamed('/novo-pedido');
        break;
    }
  }
}

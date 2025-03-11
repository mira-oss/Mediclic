import 'package:flutter/material.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
 int _selectedIndex = 0;

  final List<Widget> _pages = [
    /*DashboardPage(),
    CreateMarketPage(),
    CreateCategoryPage(),
    CreateProductPage(),
    Marchand(),
    ProfilePage(),*/
 ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marché'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Catégories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Produits'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Marchands'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      )
      
        );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [Text("mira")],
      ),
    );
  }
}

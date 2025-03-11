import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/ajout_medecin.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png')),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("Hello ,Doc"),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height:5,
        ),
        Container(
          padding: EdgeInsets.only(top:5),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list_outlined),
              ),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "DASHBORD",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 1.7,
          children: [
            _buildDashboardCard('Ajout medecin', 'assets/images/personne.jpeg',
                () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AjoutMedecin()));
            }),
            /* _buildDashboardCard(
                'Commandes en cours', 'assets/images/panier1.png', () {}),
            _buildDashboardCard(
                'Demande marchand', 'assets/images/enveloppe2.png', () {}),
            _buildDashboardCard(
                'Transactions', 'assets/images/transaction.png', () {}),*/
          ],
        ),
      ]),
    ),
    ));
    
  }

  Widget _buildDashboardCard(
      String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                backgroundColor: const Color.fromARGB(255, 37, 163, 221),
              ),
              SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

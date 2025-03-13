import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/ajout_medecin.dart';
import 'package:myhealth/liste_medecin.dart';
import 'package:myhealth/services/firestor_services.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();
  String username = "Doc";
  // bool isLoading = true;

   @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    setState(() {
     // isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
       
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          setState(() {
            username = user.displayName!;
            //isLoading = false;
          });
        } else {
          
          DocumentSnapshot userData = await _firestoreServices.getUserById(user.uid);
          if (userData.exists && userData.data() != null) {
            Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
            if (data.containsKey('username')) {
              setState(() {
                username = data['username'];
               // isLoading = false;
              });
            } else {
              setState(() {
              //  isLoading = false;
              });
            }
          } else {
            setState(() {
            //  isLoading = false;
            });
          }
        }
      } else {
        setState(() {
         // isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
      setState(() {
       // isLoading = false;
      });
    }
  }
  
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
                    backgroundImage: AssetImage('assets/images/avatar1.jpeg')),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                 child: //isLoading
                           // ? CircularProgressIndicator(strokeWidth: 2)
                             Text("Hello, $username"),
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
             _buildDashboardCard(
                'Liste des Medecins', 'assets/images/panier1.png', (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListeMedecin()));
                }),
            _buildDashboardCard(
                'Nombre de Specialité', 'assets/images/enveloppe2.png', () {}),
            _buildDashboardCard(
                'Nombre de clinique', 'assets/images/transaction.png', () {}),
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
        color: Colors.lightBlue[50], 
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                backgroundColor:  Colors.white,
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

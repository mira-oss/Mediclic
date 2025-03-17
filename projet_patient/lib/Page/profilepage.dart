import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_patient/Page/chat_page.dart';
import 'package:projet_patient/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PresentPageState();
  }
}

class _PresentPageState extends State<ProfilePage> {
  String email = '';
  String number = '';
  String username = '';

  // Fonction pour récupérer les données de l'utilisateur connecté
  Future<void> _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Récupérer les informations utilisateur depuis Firestore
      var userInfo = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .where('email', isEqualTo: user.email)
          .get();

      if (userInfo.docs.isNotEmpty) {
        setState(() {
          email = userInfo.docs[0]['email'];
          number = userInfo.docs[0]['number'];
          username = userInfo.docs[0]['username'];
        });
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Erreur de déconnexion : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 40,
                color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white,
                              width: 0,
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/image/profile.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(), // Forme ronde du bouton
                                padding: EdgeInsets.all(15), // Taille du bouton (rond)
                                elevation: 1, // Effet d'élévation
                                iconColor: Colors.white, // Couleur de fond du bouton
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage()),
                                );
                              },
                              child: Icon(
                                Icons.message, // Icône de message
                                color: Colors.blue, // Couleur bleue pour l'icône
                                size: 20, // Taille de l'icône
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(), // Forme ronde du bouton
                                padding: EdgeInsets.all(15), // Taille du bouton (rond)
                                elevation: 1, // Effet d'élévation
                                iconColor: Colors.white, // Couleur de fond du bouton
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.phone, // Icône de message
                                color: Colors.blue, // Couleur bleue pour l'icône
                                size: 20, // Taille de l'icône
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(), // Forme ronde du bouton
                                padding: EdgeInsets.all(15), // Taille du bouton (rond)
                                elevation: 1, // Effet d'élévation
                                iconColor: Colors.white, // Couleur de fond du bouton
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.videocam, // Icône de message
                                color: Colors.blue, // Couleur bleue pour l'icône
                                size: 20, // Taille de l'icône
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              email,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              number,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nom et prénom:",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  color: const Color.fromARGB(255, 231, 231, 231), // Couleur de la ligne
                  thickness: 3.0, // Épaisseur de la ligne
                  indent: 0, // Décalage du début de la ligne
                  endIndent: 0, // Décalage de la fin de la ligne
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                    Text('Données Profils',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.blue,
                      size: 30,
                    ),
                    Text('Parametre      ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _signOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(250, 50),
                  ),
                  child: Text(
                    'Deconnection',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

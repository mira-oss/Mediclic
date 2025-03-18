import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AjoutClinique extends StatefulWidget {
  const AjoutClinique({super.key});

  @override
  State<AjoutClinique> createState() => _AjoutCliniqueState();
}

class _AjoutCliniqueState extends State<AjoutClinique> {
  final TextEditingController _cliniqueController = TextEditingController();

  Future<void > _creatClinique() async{
    if(_cliniqueController.text.isEmpty ){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un  nom de clinique')),
      );
      }
      await FirebaseFirestore.instance.collection('Clinique').add({
        'nom':_cliniqueController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });
     _cliniqueController .clear();

     Fluttertoast.showToast(
                msg: "Clinique crée avec succes!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height*0.4,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50], 
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ajouter Clinique',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 159, 190, 214),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                TextField(
                  controller:  _cliniqueController,
                  decoration: InputDecoration(
                    labelText: 'Nom de la clinique',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _creatClinique,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "CRÉER CLINIQUE",
                    style: TextStyle(fontSize: 16),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AjoutSpecialite extends StatefulWidget {
  const AjoutSpecialite({super.key});

  @override
  State<AjoutSpecialite> createState() => _AjoutSpecialiteState();
}

class _AjoutSpecialiteState extends State<AjoutSpecialite> {
  final TextEditingController _specialiteController = TextEditingController();

  Future<void> _creatSpecialite() async {
    if (_specialiteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez une specialite')),
      );
    }await
     FirebaseFirestore.instance.collection('Specialite').add({
        'nom':_specialiteController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });
     _specialiteController .clear();

     /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Specialite créé avec succès'),
        backgroundColor: Colors.green,),
      );*/

      Fluttertoast.showToast(
                msg: "Specialite crée avec succes!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _specialiteController,
              decoration: const InputDecoration(labelText: 'Nom de la specialité'),
            ),
            ElevatedButton(onPressed: _creatSpecialite, 
            child: const Text("Creer specialité"))
           ],
        ),
      ),
    );
  }
}

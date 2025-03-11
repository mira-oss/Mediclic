import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AjoutMedecin extends StatefulWidget {
  const AjoutMedecin({super.key});

  @override
  State<AjoutMedecin> createState() => _AjoutMedecinState();
}

class _AjoutMedecinState extends State<AjoutMedecin> {
  final TextEditingController _medecinController = TextEditingController();

  Future<void> _creatMedecin() async{
      if(_medecinController.text.isEmpty ){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom')),
      );
      }
      await FirebaseFirestore.instance.collection('Medecin').add({
        'nom':_medecinController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });
     _medecinController .clear();

     Fluttertoast.showToast(
                msg: "Medecin crée avec succes!",
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
                 TextField(
              controller: _medecinController,
              decoration: const InputDecoration(labelText: 'Nom du medecin'),
            ),
            ElevatedButton(onPressed: _creatMedecin, child: Text("Creer medecin"))
           ],
        ),
      ),
    );
  }
}

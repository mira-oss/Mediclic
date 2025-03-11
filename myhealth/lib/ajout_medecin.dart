import 'package:flutter/material.dart';

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              child: TextField(
              controller: _medecinController,
              decoration: const InputDecoration(labelText: 'Nom du medecin'),
            ),
            
            )
          ],
        ),
      ),
    );
  }
}

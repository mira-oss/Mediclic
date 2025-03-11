import 'package:flutter/material.dart';

class Acceuilmedecin extends StatefulWidget {
  const Acceuilmedecin({super.key});

  @override
  State<Acceuilmedecin> createState() => _AcceuilmedecinState();
}

class _AcceuilmedecinState extends State<Acceuilmedecin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text("Accueil Medecin")),
    );
  }
}
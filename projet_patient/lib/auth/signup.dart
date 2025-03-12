import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projet_patient/auth/login.dart';
//import 'package:manag_app/user/user_dashboard.dart';
import 'package:projet_patient/services/firestore_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();

  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 15),
              const Center(
              child: Text(
                'Inscrivez-vous',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700, color: Color.fromARGB(255, 0, 36, 134),
                ),
              ),
            ),
                   SizedBox(height: 15,),
                  _buildTextField(username, 'Entrez votre Nom et Prénom', Icons.person, "Votre nom et prénom est obligatoire", ),
                  _buildEmailField(),
                  _buildTextField(number, 'Votre numéro de téléphone', Icons.numbers, "Le numéro est obligatoire", ),
                  _buildPasswordField(),
                  SizedBox(height: 25),
                  _buildSignUpButton(),
                  SizedBox(height: 15,),
                  _buildLoginPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, String validationMessage) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 244, 242, 255),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? validationMessage : null,
        decoration: InputDecoration(
          prefixIcon: Icon(
                        icon,
                        color: Colors.grey, // Couleur de l'icône (modifiable)
                      ),
          
          hintText: hintText,
          hintStyle: TextStyle( color: Colors.grey, fontWeight: FontWeight.bold ), // Couleur du hintText (modifiable)
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 244, 242, 255),
      ),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) return "L'email est obligatoire";
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Veuillez entrer un email valide";
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
                        Icons.mail_outlined,
                        color: Colors.grey, // Couleur de l'icône (modifiable)
                      ),
          
          hintText: 'Entrez votre email',
          hintStyle: TextStyle( color: Colors.grey, ), // Couleur du hintText (modifiable)
          labelText: 'Entrez votre email',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Couleur du label (modifiable)
                        fontWeight: FontWeight.bold, // Poids du label
                      ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 244, 242, 255),
      ),
      child: TextFormField(
        controller: password,
        validator: (value) => value!.isEmpty ? "Le mot de passe est obligatoire" : null,
        obscureText: !isVisible,
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.lock, color: Colors.grey, ),// Couleur de l'icône (modifiable)
          
          hintText: 'Entrez votre mot de passe',
          hintStyle: TextStyle( color: Colors.grey, ), // Couleur du hintText (modifiable)
          labelText: 'Veuillez entrez votre mot de passe',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Couleur du label (modifiable)
                        fontWeight: FontWeight.bold, // Poids du label
                      ),
          suffixIcon: IconButton(
            onPressed: () => setState(() => isVisible = !isVisible),
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: 340,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 36, 134),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: _signUpUser,
        child: Text(
    'S\'inscrire',
    style: TextStyle(
      fontWeight: FontWeight.bold, // Texte en gras
      fontSize: 20, // Taille de la police plus grande
      color: Colors.white,
    ),
  ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous avez un compte?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text('Connectez-vous', style: TextStyle(color: const Color.fromARGB(255, 37, 12, 255), fontWeight: FontWeight.bold, fontSize: 16),),
        ),
      ],
    );
  }

  Future<void> _signUpUser() async {
  if (formKey.currentState!.validate()) {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Ajout de l'utilisateur avec le rôle "patient" automatique
      await _firestoreServices.addUser(
        userCredential.user!.uid,
        username.text.trim(),
        email.text.trim(),
        number.text.trim(),
      );

      // Afficher un message de succès
      Fluttertoast.showToast(
        msg: "Inscription réussie",
        backgroundColor: Colors.green,
      );

      // Rediriger vers la page de connexion ou une autre page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }
}
}



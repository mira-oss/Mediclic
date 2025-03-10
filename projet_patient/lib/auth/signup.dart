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
                  Image.asset('assets/ybr.jpeg', width: 200),
                  SizedBox(height: 15),
                  _buildTextField(username, 'Username', Icons.person, "Le username est obligatoire"),
                  _buildEmailField(),
                  _buildTextField(number, 'Number', Icons.numbers, "Le numéro est obligatoire"),
                  _buildPasswordField(),
                  SizedBox(height: 15),
                  _buildSignUpButton(),
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
        color: Colors.blueAccent.withOpacity(0.5),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? validationMessage : null,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
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
        color: Colors.blueAccent.withOpacity(0.5),
      ),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) return "L'email est obligatoire";
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Veuillez entrer un email valide";
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(Icons.mail),
          border: InputBorder.none,
          hintText: 'Email',
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
        color: Colors.blueAccent.withOpacity(0.5),
      ),
      child: TextFormField(
        controller: password,
        validator: (value) => value!.isEmpty ? "Le password est obligatoire" : null,
        obscureText: !isVisible,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          border: InputBorder.none,
          hintText: 'Password',
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
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: _signUpUser,
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous avez un compte?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text('Login'),
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

      String? role = await _firestoreServices
          .determineUserRole(userCredential.user!.uid);

      if(role != null){
        await _firestoreServices.addUser(
          userCredential.user!.uid,
          username.text.trim(),
          email.text.trim(),
          number.text.trim(),
          role, // Pass the role
        );

        // ... reste de votre code ...
      }else{
        Fluttertoast.showToast(msg: "Erreur: Role non défini", backgroundColor: Colors.red);
      }

    } catch (e) {
      Fluttertoast.showToast(
          msg: "Erreur: ${e.toString()}", backgroundColor: Colors.red);
    }
  }
}
}



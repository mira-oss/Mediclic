import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projet_patient/Page/homepage.dart';
import 'package:projet_patient/auth/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
   void initState() {
    super.initState();
    checkUserLogin(); // Vérifier l'état de l'utilisateur au démarrage
  }

  void checkUserLogin() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        // L'utilisateur est déjà connecté
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AcceuilPage()),
        );
      }
    });
  }

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
                  _buildEmailField(),
                  _buildPasswordField(),
                  SizedBox(height: 15),
                  _buildLoginButton(),
                  _buildSignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Email invalide";
          return null;
        },
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
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

  Widget _buildLoginButton() {
    return Container(
      width: 320,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            try {
              await _firebaseAuth.signInWithEmailAndPassword(
                email: email.text.trim(),
                password: password.text.trim(),
              );

              // ✅ Afficher un message de succès
              Fluttertoast.showToast(
                msg: "Connexion réussie !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );

              // ✅ Rediriger vers Home après 1.5 secondes
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AcceuilPage()),
                );
              });
            } on FirebaseAuthException catch (e) {
              String message = "Une erreur s'est produite !";
              //print("FirebaseAuthException: ${e.code} - ${e.message}");
              if (e.code == 'user-not-found') {
                message = 'Aucun utilisateur trouvé pour cet email.';
              } else if (e.code == 'invalid-credential') {
                message = 'Mot de passe incorrect.';
              }

              // ✅ Afficher un toast d'erreur
              Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            } catch (e) {
              Fluttertoast.showToast(
                msg: "Erreur: $e",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          }
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: Text('Créer un compte'),
        ),
      ],
    );
  }
}

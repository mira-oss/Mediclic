import 'package:flutter/material.dart';

class DetailsMedecin extends StatefulWidget{
  const DetailsMedecin({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DetailsMedecinState();
  }
  }

  class _DetailsMedecinState extends State {
    @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
            title: Text("Détails docteur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 25),),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20 ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  elevation: 2, // Ajoute une ombre pour l'effet de carte
  child: InkWell(
    borderRadius: BorderRadius.circular(15), // Assure un effet visuel correct au clic
    onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsMedecin()),
    );
      print("Card cliquée !"); // Remplace avec ta logique de navigation
    },
    child: Container(
      height: 300,
      width: double.infinity,
      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 240, 255),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white,
          width: 0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
            children: [
              Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                            width: 0,
                          ),
                          image: DecorationImage(image: AssetImage('assets/image/docteur.png'),
                          fit: BoxFit.cover,
                          ),

                          ),
                        ),
            ],
          ),
          
          Column(
            
            children: [
              ElevatedButton(
                onPressed: () {
                  print("Bouton 'Informations' cliqué !");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(80, 50),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image(image: AssetImage("assets/image/p.png"))
                      ],
                    ),
                    SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("15 ans", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                        Text("d'expériences", style: TextStyle(color: Colors.white, fontSize: 14),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  print("Bouton 'Informations' cliqué !");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(300, 70),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Dr. Alexander Bennett, Ph.D.", style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),),
                    SizedBox(height: 10,),
                    Text("Dentiste", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
)


                ],
              ),
            ),
          ),
      ),
    );
  }
  }
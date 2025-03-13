import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsMedecin extends StatefulWidget {
  final Map<String, dynamic> medecin;

  const DetailsMedecin({super.key, required this.medecin});

  @override
  State<DetailsMedecin> createState() => _DetailsMedecinState();
}

class _DetailsMedecinState extends State<DetailsMedecin> {
  Future<void> _launchPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunch(phoneUri.toString())) {
    await launch(phoneUri.toString());
  } else {
    throw 'Impossible d\'ouvrir le composeur de téléphone avec ce numéro';
  }
}

Future<void> _launchSMS(String phoneNumber, String message) async {
  final Uri smsUri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message)}");
  if (await canLaunch(smsUri.toString())) {
    await launch(smsUri.toString());
  } else {
    throw 'Impossible d\'ouvrir l\'application de messagerie';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Détails Médecin",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 25),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 240, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: AssetImage('assets/image/docteur.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(50, 40),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image(image: AssetImage("assets/image/p.png"))
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${widget.medecin['experience']}",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text("d'expérience",
                                            style: TextStyle(color: Colors.white, fontSize: 14)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
              Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        elevation: 1,
        iconColor: Colors.white,
        padding: EdgeInsets.all(10), // Ajoute un padding de 10px
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
         _launchSMS('+2290190823631', 'Bonjour, comment allez-vous ?'); // Remplace par le numéro et message souhaité
      },
      child: Icon(
        Icons.message,
        color: Colors.blue,
        size: 16,
      ),
    ),
    SizedBox(width: 10), // Ajoute un espacement de 5px
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        elevation: 1,
        iconColor: Colors.white,
        padding: EdgeInsets.all(10), // Ajoute un padding de 10px
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        // Numéro à appeler (remplace avec le numéro réel)
    _launchPhoneDialer('+2290190823631');
      },
      child: Icon(
        Icons.phone,
        color: Colors.blue,
        size: 16,
      ),
    ),
    SizedBox(width: 10), // Ajoute un espacement de 5px
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        elevation: 1,
        iconColor: Colors.white,
        padding: EdgeInsets.all(10), // Ajoute un padding de 10px
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {},
      child: Icon(
        Icons.videocam,
        color: Colors.blue,
        size: 16,
      ),
    ),
  ],
)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white, // Couleur de fond blanche
    minimumSize: Size(290, 60), // Largeur 290px, hauteur 100px
    elevation: 1, // Élévation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Bordures carrées
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center, // Alignement vertical au centre
    crossAxisAlignment: CrossAxisAlignment.center, // Alignement horizontal au centre
    children: [
      Text(
                        "Dr. ${widget.medecin['username']}",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${widget.medecin['specialite']}",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
    ],
  ),
),
                      
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                      SizedBox(height: 10),
                      Text("Numéro:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                      SizedBox(height: 10),
                      Text("Clinique:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.medecin['email']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue)),
                      SizedBox(height: 10),
                      Text("${widget.medecin['number']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue)),
                      SizedBox(height: 10),
                      Text("${widget.medecin['clinique']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

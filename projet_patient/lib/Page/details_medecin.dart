import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsMedecin extends StatefulWidget {
  final Map<String, dynamic> medecin;

  const DetailsMedecin({super.key, required this.medecin});

  @override
  State<DetailsMedecin> createState() => _DetailsMedecinState();
}

class _DetailsMedecinState extends State<DetailsMedecin> {
  List<Map<String, dynamic>> disponibilites = [];

  Future<void> _requestPermissions() async {
    await [Permission.phone, Permission.sms].request();
  }

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

  Future<void> _launchWhatsAppVideoCall(String phoneNumber) async {
  final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
  if (await canLaunch(whatsappUri.toString())) {
    await launch(whatsappUri.toString());
  } else {
    throw 'Impossible d\'ouvrir WhatsApp';
  }
}

  Future<void> _fetchDisponibilites() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('disponibilites')
          .where('medecinId', isEqualTo: widget.medecin['id'])
          .get();

      List<Map<String, dynamic>> fetchedDisponibilites = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        disponibilites = fetchedDisponibilites;
      });
    } catch (e) {
      print("Erreur lors de la récupération des disponibilités: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchDisponibilites(); // Récupérer les disponibilités au chargement
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
                                    image: AssetImage('assets/image/noir.jpg'),
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
                              SizedBox(height: 15),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      elevation: 1,
                                      iconColor: Colors.white,
                                      padding: EdgeInsets.all(10),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      _launchSMS(widget.medecin['numero'], 'Bonjour, comment allez-vous ? J\'aimerais prendre Rendez-vous ! ');
                                    },
                                    child: Icon(
                                      Icons.message,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      elevation: 1,
                                      iconColor: Colors.white,
                                      padding: EdgeInsets.all(10),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      _launchPhoneDialer(widget.medecin['numero']);
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      elevation: 1,
                                      iconColor: Colors.white,
                                      padding: EdgeInsets.all(10),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      _launchWhatsAppVideoCall(widget.medecin['numero']);
                                    },
                                    child: Icon(
                                      Icons.videocam,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
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
                        "Dr. ${widget.medecin['nom']}",
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
                      Text("${widget.medecin['numero']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue)),
                      SizedBox(height: 10),
                      Text("${widget.medecin['clinique']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.blue)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Text("Disponibilités", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),)
                ],
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: disponibilites.isEmpty
                      ? [Text("Aucune disponibilité", style: TextStyle(color: Colors.grey, fontSize: 18))]
                      : disponibilites.map((dispo) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${dispo['jour']}:", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.blue)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dispo['heures'].map<Widget>((heure) {
                      return Text(heure, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.grey));
                    }).toList(),
                  ),
                ],
                            ),
                          );
                        }).toList(),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

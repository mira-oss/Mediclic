import 'package:flutter/material.dart';
import 'package:projet_patient/Page/chat_gemini_page.dart';
import 'package:projet_patient/materiels/pageview.dart';

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AcceuilPageState();
  }
}

class _AcceuilPageState extends State {
  // Liste des éléments à afficher dans le Row défilable
  final List<Map<String, String>> items = [
    {'image': 'assets/image/Brain Vector.png', 'title': 'Neurologie'},
    {'image': 'assets/image/Heart.png', 'title': 'Cardiologie'},
    {'image': 'assets/image/Tooth.png', 'title': 'Dentiste'},
    {'image': 'assets/image/Brain Vector.png', 'title': 'Néphrologie'},
    // Ajoute plus d'éléments ici si nécessaire
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 50),
      color:  Colors.white,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
             Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Salut Dwiky!',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Que tu sois toujours en bonne condition',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 156, 156, 156),
                      ),
                    ),
                  ],
                ),
              ],
            ),
           Column(
              children: [
                Icon(
                Icons.notifications_active_outlined,
                color: const Color.fromARGB(255, 82, 82, 82),
            ),
              ],
            )
                  ],
                ),
            Container(
              padding: EdgeInsets.only(top: 60),
              child: SingleChildScrollView(
              child: Column(
                children: [
                 
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(
                        width: 260, // Largeur du TextField
                        height: 45, // Hauteur du TextField
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'symptômes et maladies', // Label
                            hintText: 'symptômes, maladies...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                            ), // Hint text
                            prefixIcon: Icon(Icons.search, color: Colors.grey), // Icône de préfixe (recherche)
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)), // Bordure arrondie
                              borderSide: BorderSide(
                                color: Colors.grey, // Couleur de la bordure
                                width: 0.5, // Taille de la bordure
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.blue, // Couleur de la bordure lorsqu'en focus
                                width: 2,
                              ),
                            ),
                            filled: false, // Pas de fond
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 3,
                              color: Colors.blue, // Couleur de la première ligne
                            ),
                            SizedBox(height: 5), // Espacement entre les lignes
                            Container(
                              width: 20,
                              height: 3,
                              color: Colors.blue, // Couleur de la deuxième ligne
                            ),
                            SizedBox(height: 5), // Espacement entre les lignes
                            Container(
                              width: 10,
                              height: 3,
                              color: Colors.blue, // Couleur de la troisième ligne
                            ),
                          ],
                        ),
                        onPressed: () {
                          // Action lors du clic sur l'icône
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ViewPage(),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Services',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'See all',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Row défilable contenant les containers
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Permet de scroller horizontalement
                    child: Row(
                      children: items.map((item) {
                        return Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          height: 90,
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Column(
                            children: [
                              Image.asset(item['image']!),
                              SizedBox(height: 5),
                              Text(
                                item['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  SizedBox(height: 20,),
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                        print("Dossier médical cliqué !");
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Container(
              padding: const EdgeInsets.all(10),
              height: 170,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/image/Icon Illustration.png"),
                  const SizedBox(height: 5),
                  const Text(
                    "Dossier médical",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Trouver un médecin ou\nun spécialiste",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
                        ),
                  ),
                ),
                InkWell(
                  onTap: () {
                        print("Appointment avec QR cliqué !");
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Container(
              padding: const EdgeInsets.all(10),
              height: 170,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/image/Icon Illustration (1).png"),
                  const SizedBox(height: 5),
                  const Text(
                    "Prener rendez-vous!",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Faire la queue sans\nse presser",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
                        ),
                  ),
                ),
              ],
                        ),
                        const SizedBox(height: 10),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatGemini()),
    );
                        print("Consultation demandée !");
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Container(
              padding: const EdgeInsets.all(10),
              height: 170,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/image/Icon Illustration (2).png"),
                  const SizedBox(height: 5),
                  const Text(
                    "Discuté avec un AI",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Parlez à gémini",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
                        ),
                  ),
                ),
                InkWell(
                  onTap: () {
                        print("Recherche de clinique !");
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Container(
              padding: const EdgeInsets.all(10),
              height: 170,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/image/Icon Illustration (3).png"),
                  const SizedBox(height: 5),
                  const Text(
                    "Localiser une clinique",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Rechercher une clinique",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
                        ),
                  ),
                ),
              ],
                        ),
                        
                        
                  SizedBox(height: 40,)
                ],
              ),
                        ),
            ),
          ],
        ),
      
    );
  }
}

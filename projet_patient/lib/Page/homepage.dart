import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          padding: EdgeInsets.only(top: 15, left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Hi Dwiky!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'May you always in a good condition',
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
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 15, right: 20),
            child: Icon(
              Icons.notifications_active_outlined,
              color: const Color.fromARGB(255, 82, 82, 82),
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                            color: const Color.fromARGB(255, 49, 103, 252), // Couleur de la bordure lorsqu'en focus
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
                          color: const Color.fromARGB(255, 49, 103, 252), // Couleur de la première ligne
                        ),
                        SizedBox(height: 5), // Espacement entre les lignes
                        Container(
                          width: 20,
                          height: 3,
                          color: const Color.fromARGB(255, 49, 103, 252), // Couleur de la deuxième ligne
                        ),
                        SizedBox(height: 5), // Espacement entre les lignes
                        Container(
                          width: 10,
                          height: 3,
                          color: const Color.fromARGB(255, 49, 103, 252), // Couleur de la troisième ligne
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
                        color: const Color.fromARGB(255, 49, 103, 252)),
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
                        color: const Color.fromARGB(255, 49, 103, 252),
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
              Container(
                height: 200,
                width: 340,
                child: Image(image: AssetImage("assets/image/Ad box.png"),),
              ),
              SizedBox(height: 0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height:170,
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 248, 251, 255),
                      ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/image/Icon Illustration.png"),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Dossier médical',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Find a Doctor or specialist',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height:170,
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 229, 255, 230),
                      ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/image/Icon Illustration (1).png"),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Appointment with\nQR',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Queuing without the hustle',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height:170,
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 253, 236, 231),
                      ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/image/Icon Illustration (2).png"),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Request\nConsultation',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Talk to specialist',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height:170,
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 253, 239, 238),
                      ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/image/Icon Illustration (3).png"),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Locate a clinic',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                    'Purchase Medicines',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

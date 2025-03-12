import 'dart:async';  // Importation de dart:async pour utiliser Timer
import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _ViewPageState();
  }
}

class _ViewPageState extends State<ViewPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Change de page toutes les 10 secondes
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 6) {
        _currentPage++;
      } else {
        _currentPage = 0; // Réinitialise à la première page après la dernière
      }
      _pageController.animateToPage(_currentPage,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();  // Libère la mémoire du controller lorsque la vue est détruite
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 0,
        ),
      ),
      width: double.infinity,
      height: 230,
      child: PageView(
  controller: _pageController,
  children: [
    _buildImageWithBorder('assets/image/photo.jpg', "Bienvenue à vous"),
    _buildImageWithBorder('assets/image/photo1.jpg', "Trouvez les meilleurs médecins"),
    _buildImageWithBorder('assets/image/photo2.jpg', "Prenez rendez-vous en ligne"),
    _buildImageWithBorder('assets/image/photo3.jpg', "Consultez vos dossiers médicaux"),
    _buildImageWithBorder('assets/image/photo4.jpg', "Localisez les cliniques proches"),
    _buildImageWithBorder('assets/image/photo5.jpg', "Obtenez des conseils de spécialistes"),
    _buildImageWithBorder('assets/image/photo6.png', "Votre santé, notre priorité"),
  ],
),

    );
  }

  // Widget pour appliquer bordure et opacité à chaque image
 Widget _buildImageWithBorder(String imagePath, String text) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.3), // Effet fumé
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20), // Pour éviter que le texte touche les bords
        child: Text(
          text,
          textAlign: TextAlign.center, // Centrer le texte
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}


}

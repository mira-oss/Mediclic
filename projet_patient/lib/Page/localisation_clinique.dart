import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LocationData? _currentLocation;
  Location _location = Location();
  MapController _mapController = MapController();

  // Liste fictive des cliniques avec leurs coordonnées
  List<Map<String, dynamic>> clinics = [
    {'name': 'Clinique A', 'lat': 1.2912, 'lng': 103.8660},
    {'name': 'Clinique B', 'lat': 1.2895, 'lng': 103.8690},
    {'name': 'Clinique C', 'lat': 1.2920, 'lng': 103.8630},
    {'name': 'Clinique D', 'lat': 1.2800, 'lng': 103.8800}, // Une clinique plus éloignée
  ];

  final Distance _distance = Distance();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fonction pour obtenir la position actuelle
  Future<void> _getCurrentLocation() async {
    try {
      var location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
      // Déplace la carte vers la position actuelle
      _mapController.move(LatLng(location.latitude!, location.longitude!), 15.0);
    } catch (e) {
      print("Erreur lors de la récupération de la localisation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localiser une clinique', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w800)),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator()) // Affiche un indicateur de chargement si la position est encore en cours de récupération
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                // Remplacement de 'center' par 'initialCenter' et 'zoom' par 'initialZoom'
                initialCenter: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!), // Position initiale
                initialZoom: 15.0, // Zoom initial
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: [
                    // Marqueur pour la position actuelle
                    Marker(
                      point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    // Marqueurs pour les cliniques proches
                    ..._buildNearbyClinicMarkers(),
                  ],
                ),
              ],
            ),
    );
  }

  // Créer des marqueurs pour les cliniques proches (moins de 5 km)
  List<Marker> _buildNearbyClinicMarkers() {
    List<Marker> markers = [];

    if (_currentLocation != null) {
      final currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

      for (var clinic in clinics) {
        final clinicLatLng = LatLng(clinic['lat'], clinic['lng']);
        
        // Calcul de la distance entre la position actuelle et la clinique
        final distanceInKm = _distance.as(LengthUnit.Kilometer, currentLatLng, clinicLatLng);

        // Si la clinique est à moins de 5 km
        if (distanceInKm <= 5) {
          markers.add(Marker(
            point: clinicLatLng,
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                // Afficher un message avec le nom de la clinique
                print('Clinique proche: ${clinic['name']}');
              },
              child: Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40.0,
              ),
            ),
          ));
        }
      }
    }

    return markers;
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: "dev.fleaflet.flutter_map.example",
      );
}

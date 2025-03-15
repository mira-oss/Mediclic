import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LocationData? _currentLocation;
  Location _location = Location();
  MapController _mapController = MapController();
  final latlng.Distance _distance = latlng.Distance();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Liste fictive des cliniques avec leurs coordonnées au Bénin (Cotonou et environs)
  List<Map<String, dynamic>> clinics = [
    {'name': 'Clinique A', 'lat': 6.3703, 'lng': 2.3912}, // Centre-ville de Cotonou
    {'name': 'Clinique B', 'lat': 6.3655, 'lng': 2.4256}, // Quartier proche
    {'name': 'Clinique C', 'lat': 6.3500, 'lng': 2.4300}, // Un peu plus loin
    {'name': 'Clinique D', 'lat': 6.2900, 'lng': 2.4100}, // Hors de Cotonou (Ouidah)
    {'name': 'Clinique E', 'lat': 6.4500, 'lng': 2.3500}, // Abomey-Calavi
  ];

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
      _mapController.move(latlng.LatLng(location.latitude!, location.longitude!), 14.0);
    } catch (e) {
      print("Erreur lors de la récupération de la localisation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localiser une clinique',
            style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher une clinique",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _currentLocation == null
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: latlng.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      initialZoom: 14.0,
                    ),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(
                        markers: [
                          // Marqueur pour la position actuelle
                          Marker(
                            point: latlng.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                            child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
                          ),
                          // Marqueurs pour les cliniques proches
                          ..._buildNearbyClinicMarkers(),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Créer des marqueurs pour les cliniques proches (moins de 15 km)
  List<Marker> _buildNearbyClinicMarkers() {
    List<Marker> markers = [];

    if (_currentLocation != null) {
      final currentLatLng = latlng.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

      for (var clinic in clinics) {
        final clinicLatLng = latlng.LatLng(clinic['lat'], clinic['lng']);

        // Calcul de la distance entre la position actuelle et la clinique
        final distanceInKm = _distance.as(latlng.LengthUnit.Kilometer, currentLatLng, clinicLatLng);

        // Si la clinique est à moins de 15 km et correspond à la recherche
        if (distanceInKm <= 15 && (_searchQuery.isEmpty || clinic['name'].toLowerCase().contains(_searchQuery.toLowerCase()))) {
          markers.add(Marker(
            point: clinicLatLng,
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () => _showClinicDialog(clinic['name']),
              child: Icon(Icons.local_hospital, color: Colors.blue, size: 40.0),
            ),
          ));
        }
      }
    }

    return markers;
  }

  // Fonction pour afficher une boîte de dialogue avec le nom de la clinique
  void _showClinicDialog(String clinicName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Clinique Proche"),
        content: Text("Vous êtes proche de $clinicName"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: "dev.fleaflet.flutter_map.example",
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LocationData? _currentLocation;
  Location _location = Location();
  MapController _mapController = MapController();
  List<Map<String, dynamic>> _clinics = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
      _mapController.move(
        latlng.LatLng(location.latitude!, location.longitude!),
        14.0,
      );
      _getHealthFacilities(location.latitude!, location.longitude!); // Récupérer les cliniques proches
    } catch (e) {
      print("Erreur lors de la récupération de la localisation: $e");
    }
  }

  // Fonction pour récupérer les établissements de santé à proximité via Overpass API
  Future<void> _getHealthFacilities(double lat, double lon) async {
    try {
      final facilities = await getHealthFacilities(lat, lon);
      setState(() {
        _clinics = facilities;
      });
    } catch (e) {
      print("Erreur lors de la récupération des cliniques: $e");
    }
  }

  // Fonction pour rechercher les établissements de santé dans une ville via l'API Overpass
  Future<void> _searchClinicsInCity(String cityName) async {
    // Tu devras remplacer cette partie avec la géolocalisation de la ville ou utiliser un service externe
    // Pour le moment, nous allons supposer que la ville est Cotonou et utiliser une requête Overpass pour cette ville
    final lat = 6.3660; // Latitude de Cotonou (exemple)
    final lon = 2.4270; // Longitude de Cotonou (exemple)
    
    final facilities = await getHealthFacilities(lat, lon);
    setState(() {
      _clinics = facilities;
    });
  }

  // Récupérer les établissements de santé via Overpass API
  Future<List<Map<String, dynamic>>> getHealthFacilities(double lat, double lon) async {
    final url = Uri.parse('https://overpass-api.de/api/interpreter');
    final query = '''
      [out:json];
      (
        node["amenity"="hospital"](around:15000,$lat,$lon);
        node["amenity"="clinic"](around:15000,$lat,$lon);
      );
      out body;
    ''';

    final response = await http.post(url, body: {'data': query});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, dynamic>> facilities = [];
      for (var element in data['elements']) {
        facilities.add({
          'name': element['tags']['name'] ?? 'Inconnu',
          'lat': element['lat'],
          'lon': element['lon'],
        });
      }
      return facilities;
    } else {
      throw Exception('Erreur de récupération des données');
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
                labelText: "Rechercher une clinique ou une ville",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (_searchQuery.isNotEmpty) {
                  // Effectuer la recherche des cliniques dans la ville donnée
                  _searchClinicsInCity(_searchQuery);
                }
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
                          // Marqueurs pour les établissements de santé proches
                          ..._buildClinicMarkers(),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Créer des marqueurs pour les cliniques proches
  List<Marker> _buildClinicMarkers() {
    List<Marker> markers = [];

    for (var clinic in _clinics) {
      final clinicLatLng = latlng.LatLng(clinic['lat'], clinic['lon']);
      if (_searchQuery.isEmpty || clinic['name'].toLowerCase().contains(_searchQuery.toLowerCase())) {
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

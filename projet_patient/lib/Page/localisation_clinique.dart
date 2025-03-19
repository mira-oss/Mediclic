import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      _clinics.addAll(facilities); // Ajouter les cliniques réelles aux emplacements fictifs
    });
  } catch (e) {
    print("Erreur lors de la récupération des cliniques: $e");
  }
}

  // Récupérer les établissements de santé à proximité via Overpass API
  Future<List<Map<String, dynamic>>> getHealthFacilities(double lat, double lon) async {
    final url = Uri.parse('https://overpass-api.de/api/interpreter');
    final query = '''
      [out:json];
      (
        node["amenity"="hospital"](around:15000,$lat,$lon);
        node["amenity"="clinic"](around:15000,$lat,$lon);
        way["amenity"="hospital"](around:15000,$lat,$lon);
        way["amenity"="clinic"](around:15000,$lat,$lon);
        relation["amenity"="hospital"](around:15000,$lat,$lon);
        relation["amenity"="clinic"](around:15000,$lat,$lon);
      );
      out center;
    ''';


    final response = await http.post(url, body: {'data': query});
    print("Réponse Overpass : ${response.body}");

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

  // Fonction pour rechercher la ville avec l'API Nominatim
  Future<void> _searchCity(String cityName) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?city=$cityName&format=json&addressdetails=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final city = data[0];
        final lat = double.parse(city['lat']);
        final lon = double.parse(city['lon']);
        _mapController.move(latlng.LatLng(lat, lon), 14.0); // Centrer la carte sur la ville
      }
    } else {
      print("Erreur lors de la recherche de la ville");
    }
  }

  // Fonction pour centrer la carte sur la clinique choisie
  void _centerMapOnClinic(Map<String, dynamic> clinic) {
    _mapController.move(
      latlng.LatLng(clinic['lat'], clinic['lon']),
      25.0, // zoom sur la clinique
    );
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

                // Chercher la clinique ou la ville correspondante
                if (_searchQuery.isNotEmpty) {
                  _searchClinicOrCity(_searchQuery);
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
                      initialZoom: 11.0,
                    ),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(
                        markers: [
                          // Marqueur pour la position actuelle
                          Marker(
                            point: latlng.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                            child: Icon(Icons.location_pin, color: Colors.red, size: 40.0),
                          ),
                          // Marqueurs pour les établissements de santé proches
                          ..._buildClinicMarkers(),
                        ],
                      ),

                      MarkerLayer(
                        markers: [
                          // Marqueur pour la position fictive
                          Marker(
                            point:  latlng.LatLng(6.43339, 2.34978),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43237, 2.34643),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: FaIcon(FontAwesomeIcons.plus, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43476, 2.34459),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43817, 2.34549),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43949, 2.34339),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43386, 2.34201),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.44976, 2.34970),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.health_and_safety_outlined, color: Colors.redAccent, size: 40.0),
                          ),
                           Marker(
                            point:  latlng.LatLng(6.44148, 2.34808),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.44831, 2.35478),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.44609, 2.34422),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43405, 2.34215),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.43798, 2.33331),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                          Marker(
                            point:  latlng.LatLng(6.46638, 2.33837),
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.medication_outlined, color: Colors.green, size: 40.0),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Rechercher une clinique ou une ville
  void _searchClinicOrCity(String query) {
    // Si le texte de la recherche est une ville, chercher la ville
    _searchCity(query);

    // Sinon chercher la clinique
    for (var clinic in _clinics) {
      if (clinic['name'].toLowerCase().contains(query.toLowerCase())) {
        _centerMapOnClinic(clinic); // Centrer la carte sur la clinique
        break;
      }
    }
  }

  // Créer des marqueurs pour les cliniques proches
  List<Marker> _buildClinicMarkers() {
  List<Marker> markers = [];

  for (var clinic in _clinics) {
    final clinicLatLng = latlng.LatLng(clinic['lat'], clinic['lon']);
    if (_searchQuery.isEmpty || clinic['name'].toLowerCase().contains(_searchQuery.toLowerCase())) {
      markers.add(Marker(
        point: clinicLatLng,
        width: 200,
        height: 200,
        child: GestureDetector(
          onTap: () => _showClinicDialog(clinic['name']),
          child: Icon(Icons.location_on, color: Colors.blue, size: 40.0),
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


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
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

// Fonction pour ajouter les emplacements fictifs
void _addFakeLocations(double lat, double lon) {
  final distance = 5.0; // 5 km
  final bearing = [0.0, 90.0, 180.0, 270.0]; // Directions (Nord, Est, Sud, Ouest)
  final double earthRadius = 6371.0; // Rayon de la Terre en km

  for (var i = 0; i < 4; i++) {
    final double bearingRad = bearing[i] * math.pi / 180.0; // Angle en radians
    final double latRad = lat * math.pi / 180.0;
    final double lonRad = lon * math.pi / 180.0;
    final double distanceRad = distance / earthRadius;

    final double newLatRad = math.asin(math.sin(latRad) * math.cos(distanceRad) +
        math.cos(latRad) * math.sin(distanceRad) * math.cos(bearingRad));

    final double newLonRad = lonRad +
        math.atan2(math.sin(bearingRad) * math.sin(distanceRad) * math.cos(latRad),
            math.cos(distanceRad) - math.sin(latRad) * math.sin(newLatRad));

    final double newLat = newLatRad * 180.0 / math.pi;
    final double newLon = newLonRad * 180.0 / math.pi;

    _clinics.add({
      'name': 'Emplacement Fictif ${i + 1}',
      'lat': newLat,
      'lon': newLon,
    });
  }
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
    _addFakeLocations(location.latitude!, location.longitude!); // Ajouter les emplacements fictifs
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
      16.0, // zoom sur la clinique
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
        width: 80,
        height: 80,
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

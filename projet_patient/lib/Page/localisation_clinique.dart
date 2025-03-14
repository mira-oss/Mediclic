import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localiser une clinique', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w800)),
      ),
      body: content(),
    );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(1.2878, 103.8666),
        initialZoom: 11,
        interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom)
      ), 
      children: [
        openStreetMapTileLayer,
      ]
      );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    userAgentPackageName: "dev.fleaflet.flutter_map.example",

  );
}



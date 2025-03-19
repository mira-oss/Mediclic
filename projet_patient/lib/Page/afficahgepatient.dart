import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientRecordViewScreen extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  PatientRecordViewScreen({required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dossier Médical'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Informations ', patientRecord['informationsPersonnelles']),
            _buildSection('Traitements ', patientRecord['traitementsAnterieurs']),
            _buildSection('Antécédents', patientRecord['antecedents']),
            _buildSection('Allergies', patientRecord['allergies']),
            _buildSection('Déparasitage', patientRecord['deparasitage']),
            _buildSection('Enquête Sociale', patientRecord['enqueteSociale']),
            _buildSection('Examen Physique', patientRecord['examenPhysique']),
            _buildSection('Diagnostic', patientRecord['diagnostic']),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return SizedBox.shrink();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Text(
                  data.containsKey('date') ? 'Maj: ${data['date']}' : '',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...data.entries.where((entry) => entry.key != 'date').map((entry) {
              if (entry.value is List) {
                return _buildListInfo(entry.key, entry.value as List<dynamic>);
              } else {
                return _buildInfoRow(entry.key, entry.value);
              }
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    if (value == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: value is String && value.startsWith('http')
                ? InkWell(
                    onTap: () => _launchUrl(value),
                    child: Text(
                      'Voir le document',
                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  )
                : Text(
                    value?.toString() ?? 'Non renseigné',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildListInfo(String label, List<dynamic> data) {
    if (data.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ...data.map((item) {
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '- $item',
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
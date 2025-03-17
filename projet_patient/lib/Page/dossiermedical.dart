import 'package:flutter/material.dart';

class MedicalRecordView extends StatelessWidget {
  final Map<String, dynamic> patientRecord;
  final VoidCallback onUpdate;

  MedicalRecordView({required this.patientRecord, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dossier Médical'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onUpdate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection('Informations Personnelles', patientRecord['informationsPersonnelles']),
            _buildSection('Traitements Antérieurs', patientRecord['traitementsAnterieurs']),
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

  Widget _buildSection(String title, dynamic data) {
    if (data == null || (data is Map && data.isEmpty)) {
      return SizedBox.shrink(); // Si la section est vide je n'affiche rien
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 10),
            if (data is Map<String, dynamic>)
              ...data.entries.map((entry) {
                if (entry.key == 'date') {
                  return _buildDateRow(entry.value);
                } else if (entry.value is Map<String, dynamic>) {
                  return _buildSubSection(entry.key, entry.value);
                } else if (entry.value is List<dynamic>) {
                  return _buildListInfo(entry.key, entry.value);
                } else {
                  return _buildInfoRow(entry.key, entry.value);
                }
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        ...data.entries.map((entry) {
          if (entry.key == 'date') {
            return _buildDateRow(entry.value);
          } else if (entry.value is List<dynamic>) {
            return _buildListInfo(entry.key, entry.value);
          } else {
            return _buildInfoRow(entry.key, entry.value);
          }
        }).toList(),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
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
            child: Text(
              value?.toString() ?? 'Non renseigné',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListInfo(String label, dynamic data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (data == null || (data is List && data.isEmpty))
            Text('Aucune information', style: TextStyle(fontSize: 16)),
          if (data is List<dynamic>)
            ...data.map((item) {
              return Text(
                '- $item',
                style: TextStyle(fontSize: 16),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildDateRow(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        'Date d\'enregistrement : $date',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
      ),
    );
  }
}
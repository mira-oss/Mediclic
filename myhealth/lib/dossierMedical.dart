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
            _buildSection('Informations Personnelles', [
              _buildInfoRow('Taille', patientRecord['informationsPersonnelles']?['taille']),
              _buildInfoRow('Poids', patientRecord['informationsPersonnelles']?['poids']),
              _buildInfoRow('Groupe Sanguin', patientRecord['informationsPersonnelles']?['groupeSanguin']),
            ]),
            _buildSection('Traitements Antérieurs', [
              _buildListInfo('Médicaments précédents', patientRecord['traitementsAnterieurs']?['medicamentsPrecedents']),
              _buildListInfo('Interventions chirurgicales', patientRecord['traitementsAnterieurs']?['interventionsChirurgicales']),
              _buildListInfo('Thérapies suivies', patientRecord['traitementsAnterieurs']?['therapiesSuivies']),
            ]),
            _buildSection('Antécédents', [
              _buildListInfo('Antécédents médicaux', patientRecord['antecedents']?['medicaux']),
              _buildListInfo('Antécédents chirurgicaux', patientRecord['antecedents']?['chirurgicaux']),
              _buildListInfo('Antécédents gynéco-obstétriques', patientRecord['antecedents']?['gynecoObstetriques']),
              _buildListInfo('Antécédents familiaux', patientRecord['antecedents']?['familiaux']),
            ]),
            _buildSection('Allergies', [
              _buildListInfo('Allergies médicamenteuses', patientRecord['allergies']?['medicaments']),
              _buildListInfo('Réactions observées', patientRecord['allergies']?['reactionsObservees']),
              _buildListInfo('Allergies alimentaires', patientRecord['allergies']?['alimentaires']),
            ]),
            _buildSection('Déparasitage', [
              _buildInfoRow('Type de traitement', patientRecord['deparasitage']?['typeTraitement']),
              _buildInfoRow('Fréquence', patientRecord['deparasitage']?['frequence']),
            ]),
            _buildSection('Enquête Sociale', [
              _buildInfoRow('Situation familiale', patientRecord['enqueteSociale']?['situationFamiliale']),
              _buildInfoRow('Profession', patientRecord['enqueteSociale']?['profession']),
              _buildInfoRow('Habitudes alimentaires', patientRecord['enqueteSociale']?['habitudesAlimentaires']),
            ]),
            _buildSection('Examen Physique', [
              _buildInfoRow('Nom de l\'examen', patientRecord['examenPhysique']?['nomExamen']),
              _buildInfoRow('Résultat de l\'examen', patientRecord['examenPhysique']?['resultatExamen']),
            ]),
            _buildSection('Diagnostic', [
              _buildInfoRow('Hypothèses diagnostiques', patientRecord['diagnostic']?['hypothesesDiagnostiques']),
              _buildInfoRow('Diagnostic final', patientRecord['diagnostic']?['diagnosticFinal']),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
            ...children,
          ],
        ),
      ),
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
          if (data == null || (data is Map && data.isEmpty) || (data is List && data.isEmpty))
            Text('Aucune information', style: TextStyle(fontSize: 16)),
          if (data is Map<String, dynamic>)
            ...data.entries.map((entry) {
              return Text(
                '- ${entry.key} : ${entry.value}',
                style: TextStyle(fontSize: 16),
              );
            }).toList(),
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
}
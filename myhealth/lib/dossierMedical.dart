import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalRecordView extends StatelessWidget {
  final Map<String, dynamic> patientRecord;
  final VoidCallback onUpdate;

  MedicalRecordView({required this.patientRecord, required this.onUpdate});
  Widget _buildExamenPhysique(Map<String, dynamic>? examenPhysique) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Examen Physique : ', style: TextStyle(fontWeight: FontWeight.bold)),
      if (examenPhysique == null || examenPhysique.isEmpty)
        Text('Aucun examen physique enregistré'),
      if (examenPhysique != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- Nom de l\'examen : ${examenPhysique['nomExamen']}'),
            Text('- Date : ${examenPhysique['date']}'),
            if (examenPhysique['resultatExamen'] != null)
              InkWell(
                onTap: () {
                  // Ouvrir le fichier PDF dans une nouvelle fenêtre ou le télécharger
                  launch(examenPhysique['resultatExamen']);
                },
                child: Text(
                  '- Résultat de l\'examen : Télécharger le PDF',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations personnelles
          _buildSectionTitle('Informations Personnelles'),
          _buildInfoRow('Taille', patientRecord['informationsPersonnelles']['taille']),
          _buildInfoRow('Poids', patientRecord['informationsPersonnelles']['poids']),
          _buildInfoRow('Groupe Sanguin', patientRecord['informationsPersonnelles']['groupeSanguin']),

          // Traitements antérieurs
          _buildSectionTitle('Traitements Antérieurs'),
          _buildListInfo('Médicaments précédents', patientRecord['traitementsAnterieurs']['medicamentsPrecedents']),
          _buildListInfo('Interventions chirurgicales', patientRecord['traitementsAnterieurs']['interventionsChirurgicales']),
          _buildListInfo('Thérapies suivies', patientRecord['traitementsAnterieurs']['therapiesSuivies']),

          // Antécédents
          _buildSectionTitle('Antécédents'),
          _buildListInfo('Antécédents médicaux', patientRecord['antecedents']['medicaux']),
          _buildListInfo('Antécédents chirurgicaux', patientRecord['antecedents']['chirurgicaux']),
          _buildListInfo('Antécédents gynéco-obstétriques', patientRecord['antecedents']['gynecoObstetriques']),
          _buildListInfo('Antécédents familiaux', patientRecord['antecedents']['familiaux']),

          // Allergies
          _buildSectionTitle('Allergies'),
          _buildListInfo('Allergies médicamenteuses', patientRecord['allergies']['medicaments']),
          _buildListInfo('Réactions observées', patientRecord['allergies']['reactionsObservees']),
          _buildListInfo('Allergies alimentaires', patientRecord['allergies']['alimentaires']),

          // Déparasitage
          _buildSectionTitle('Déparasitage'),
          _buildInfoRow('Type de traitement', patientRecord['deparasitage']['typeTraitement']),
          _buildInfoRow('Fréquence', patientRecord['deparasitage']['frequence']),

          // Enquête sociale
          _buildSectionTitle('Enquête Sociale'),
          _buildInfoRow('Situation familiale', patientRecord['enqueteSociale']['situationFamiliale']),
          _buildInfoRow('Profession', patientRecord['enqueteSociale']['profession']),
          _buildInfoRow('Habitudes alimentaires', patientRecord['enqueteSociale']['habitudesAlimentaires']),

          // Examen physique
          _buildSectionTitle('Examen Physique'),
          _buildInfoRow('Nom de l\'examen', patientRecord['examenPhysique']['nomExamen']),
          _buildInfoRow('Résultat de l\'examen', patientRecord['examenPhysique']['resultatExamen']),

          // Diagnostic
          _buildSectionTitle('Diagnostic'),
          _buildInfoRow('Hypothèses diagnostiques', patientRecord['diagnostic']['hypothesesDiagnostiques']),
          _buildInfoRow('Diagnostic final', patientRecord['diagnostic']['diagnosticFinal']),

          // Bouton de mise à jour
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: onUpdate,
              child: Text('Mettre à jour le dossier'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$label : ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'Non renseigné'),
        ],
      ),
    );
  }

 Widget _buildListInfo(String label, Map<String, dynamic>? data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$label : ', style: TextStyle(fontWeight: FontWeight.bold)),
      if (data == null || data.isEmpty)
        Text('Aucune information'),
      if (data != null)
        ...data.entries.map((entry) {
          if (entry.key == 'date') {
            return Text('- Date : ${entry.value}');
          } else {
            return Text('- ${entry.key} : ${entry.value}');
          }
        }).toList(),
    ],
  );
}
}
// lib/screens/widgets/incident_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data/hora
import 'package:projeto_704apps/features/models/incident.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final int occurrenceNumber;

  const IncidentCard({
    Key? key,
    required this.incident,
    required this.occurrenceNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formata a data e hora
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ocorrência ${occurrenceNumber.toString().padLeft(3, '0')}', // Formato 001
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Nível:', '${incident.level} (${incident.levelName})'),
            _buildDetailRow('Data/Hora:', dateFormat.format(incident.timestamp)),
            _buildDetailRow('Local:', incident.location),
            _buildDetailRow('Descrição:', incident.description),
            _buildDetailRow('Ação do Sistema:', incident.systemAction),
            if (incident.audioTranscription != null && incident.audioTranscription!.isNotEmpty)
              _buildAudioTranscriptionBox(incident.audioTranscription!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTranscriptionBox(String transcription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Texto do áudio da ligação',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            transcription,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
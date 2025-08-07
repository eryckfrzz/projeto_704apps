// lib/features/models/incident.dart
class Incident {
  final String id;
  final int level;
  final DateTime timestamp;
  final String location;
  final String description;
  final String systemAction;
  final String? audioTranscription;
  // Para o "Texto do áudio da ligação"
  // ... outros campos que você já tenha, como 'date' (timestamp pode ser suficiente)

  Incident({
    required this.id,
    required this.level,
    required this.timestamp,
    required this.location,
    required this.description,
    required this.systemAction,
    this.audioTranscription,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String,
      level: json['level'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: json['location'] as String,
      description: json['description'] as String,
      systemAction: json['systemAction'] as String,
      audioTranscription: json['audioTranscription'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'description': description,
      'systemAction': systemAction,
      'audioTranscription': audioTranscription,
    };
  }

  String get levelName {
    switch (level) {
      case 1:
        return 'Leve';
      case 2:
        return 'Atenão';
      case 3:
        return 'Atenção';
      case 6:
        return 'Grave';
      default:
        return 'Desconhecido';
    }
  }
}

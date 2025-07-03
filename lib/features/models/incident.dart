class Incident {
  final String id;

  final String description;
  final DateTime date;
  final String location;
   final DateTime timestamp;

  Incident({
    required this.id,
    required this.description,
    required this.date,
    required this.location,
    required this.timestamp
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'date': date.toLocal(),
      'location': location,
     
      
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
     
      description: json['description'],
      date: json['date'],
      location: json['location'],
    
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

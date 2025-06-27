class Incident {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int level;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'date': date.toLocal(),
      'location': location,
      'level': level,
    };
  }

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      location: json['location'],
      level: json['level'],
    );
  }
}

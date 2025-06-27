class Contact {
  int id;
  String title;
  String number;
  String instanceEmitter;

  Contact({
    required this.title,
    required this.number,
    required this.id,
    required this.instanceEmitter,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'title': title, 'number': number, 'id': id};
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      title: json['title'] as String,
      number: json['number'] as String,
      instanceEmitter: json['instanceEmitter'],
    );
  }
}

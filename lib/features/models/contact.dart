class Contact {
  // int id;
  String title;
  String number;
  bool isEmitter;

  Contact({
    required this.title,
    required this.number,
    // required this.id,
    required this.isEmitter,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'title': title, 'number': number,  'isEmitter': isEmitter };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      // id: json['id'] as int,
      title: json['title'] as String,
      number: json['number'] as String,
      isEmitter: json['isEmitter'] as bool,
    );
  }
}

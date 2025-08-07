class Badword {
  String word;
  final String? group;
  int? userId;

  Badword({required this.word, this.userId, this.group});

  Map<String, dynamic> toJson() {
    return {'word': word, 'userId': userId};
  }

  factory Badword.fromjson(Map<String, dynamic> json) {
    return Badword(word: json['word'], userId: json['userId'] as int?, group: json['group'] as String?);
  }
}

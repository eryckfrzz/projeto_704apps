class Badword {
  String badwordId;
  String word;

  Badword({required this.badwordId, required this.word});

  Map<String, dynamic> toJson() {
    return {'badwordId': badwordId, 'word': word};
  }

  factory Badword.fromjson(Map<String, dynamic> json) {
    return Badword(badwordId: json['badwordId'], word: json['word']);
  }
}

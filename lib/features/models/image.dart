class Image {
  List<String> paths;
  String audioTranscriptionId;

  Image({required this.paths, required this.audioTranscriptionId});

  Map<String, dynamic> toJaon() {
    return <String, dynamic>{
      'paths': paths,
      'audioTranscriptionId': audioTranscriptionId,
    };
  }

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      paths: json['paths'],
      audioTranscriptionId: json['audioTranscriptionId'],
    );
  }
}

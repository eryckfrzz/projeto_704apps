class ListImages {
  List<String>? paths;
  // String audioTranscriptionId;

  ListImages({required this.paths});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'paths': paths,
      // 'audioTranscriptionId': audioTranscriptionId,
    };
  }
 
  factory ListImages.fromJson(Map<String, dynamic> json) {
    return ListImages(
      paths: json['paths'],
      // audioTranscriptionId: json['audioTranscriptionId'],
    );
  }
}

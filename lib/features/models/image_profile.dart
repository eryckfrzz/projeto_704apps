class ImageProfile {
  String? file;

  ImageProfile({required this.file});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'file': file};
  }

  factory ImageProfile.fromJson(Map<String, dynamic> json) {
    return ImageProfile(file: json['file'] as String?);
  }
}

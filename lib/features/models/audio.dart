class Audio {
 final String id;
  final bool isHostile;

  Audio({required this.id, required this.isHostile});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'audioId': id, 'audioType': isHostile};
  }

   factory Audio.fromjson(Map<String, dynamic> json) {
    return Audio(id: json['id'], isHostile: json['isHostile']);
  }
}

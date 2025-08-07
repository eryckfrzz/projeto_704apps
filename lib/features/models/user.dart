class User {
  int? id;
  String? email;
  String? name;
  String? password;
  String? role;
  // bool? userApp = false;
  String? phone;
  String? adress;
  String? whatsapp;
  String? moreInfo;
  String? extraInfos;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    //required this.role,
    // required this.userApp,
    required this.phone,
    required this.adress,
    required this.whatsapp,
    required this.extraInfos, 
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      //'role': role,
      // 'userApp': userApp,
      'phone': phone,
      'adress': adress,
      'whatsapp': whatsapp,
      'extraInfos': extraInfos
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Verifica se a chave 'user' existe no JSON (estrutura de login)
    final Map<String, dynamic>? userJson = json['user'] as Map<String, dynamic>?;

    // Se 'userJson' não for nulo, usamos os dados de dentro dele.
    // Caso contrário, usamos o próprio 'json' (estrutura da tela de perfil).
    final Map<String, dynamic> dataToParse = userJson ?? json;

    return User(
      id: dataToParse['id'] as int?,
      email: dataToParse['email'] as String?,
      name: dataToParse['name'] as String?,
      password: dataToParse['password'] as String?,
      // userApp: dataToParse['userApp'] as bool?, // Descomente se 'userApp' for usado
      phone: dataToParse['phone'] as String?, // Removida interpolação desnecessária
      whatsapp: dataToParse['whatsapp'] as String?,
      adress: dataToParse['adress'] as String?, // Note a grafia 'adress'
      extraInfos: dataToParse['extraInfos'] as String?,
      
    );
  }
}

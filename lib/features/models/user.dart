class User {
  int id;
  String? email;
  String? name;
  String? password;
  String? role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
    );
  }
}

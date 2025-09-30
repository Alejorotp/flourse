class AuthenticationUser {
  String? id;
  final String email;
  final String name;
  final String? password;

  AuthenticationUser({
    this.id,
    required this.email,
    required this.name,
    this.password,
  });

  factory AuthenticationUser.fromJson(Map<String, dynamic> json) {
    return AuthenticationUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'password': password};
  }
}

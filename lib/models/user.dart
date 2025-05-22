class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.token,
  });

  // Factory constructor to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }
}

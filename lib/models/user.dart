class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  User({this.id, this.name, this.image, this.email, this.token});

  // Factory constructor to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}

class User {
  final String id;
  final String name;
  final String login;
  final String email;
  final String phoneNumber;
  final bool isAdmin;
  List<String> favoriteCars;

  User({
    this.id = '',
    this.name = '',
    this.login = '',
    this.email = '',
    this.phoneNumber = '',
    this.isAdmin = false,
    List<String>? favoriteCars,
  }) : favoriteCars = favoriteCars ?? [];

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      name: data['name'] ?? '',
      login: data['login'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      favoriteCars: List<String>.from(data['favoriteCars'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'login': login,
      'email': email,
      'phoneNumber': phoneNumber,
      'isAdmin': isAdmin,
      'favoriteCars': favoriteCars,
    };
  }
}

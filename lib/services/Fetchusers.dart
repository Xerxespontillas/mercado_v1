class Users {

  final String username;
  final String password;

  const Users({
    required this.username,
    required this.password,

  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      username: json['username'],
      password: json['title'],
    );
  }
}
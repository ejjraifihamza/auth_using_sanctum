class User {
  late String name;
  late String email;
  late String avatar;
  User({
    required this.name,
    required this.email,
    required this.avatar,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'];
}

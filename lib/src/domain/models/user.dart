import 'package:rapidito/src/domain/models/Role.dart';

class User {
  final int? id;
  final String name;
  final String lastName;
  final String email;
  final String? password;
  final String phone;
  final String? image;
  final String? notificationToken;
  final List<Role>? roles;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.password,
    required this.phone,
    this.image,
    this.notificationToken,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    password: json["password"],
    notificationToken: json["notification_token"],
    roles: json["roles"] != null
        ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "last_name": lastName,
    "email": email,
    "password": password,
    "phone": phone,
    "image": image,
    "notification_token": notificationToken,
    "roles": roles != null
        ? List<dynamic>.from(roles!.map((x) => x.toJson()))
        : [],
  };
}

// To parse this JSON data, do
//
//     final perfil = perfilFromJson(jsonString);

import 'dart:convert';

Perfil perfilFromJson(String str) => Perfil.fromJson(json.decode(str));

String perfilToJson(Perfil data) => json.encode(data.toJson());

class Perfil {
  Perfil({
    required this.ci,
    required this.name,
    required this.telefono,
    required this.email,
    required this.uuid,
  });

  String ci;
  String name;
  String telefono;
  String email;
  String uuid;

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
        ci: json["ci"],
        name: json["name"],
        telefono: json["telefono"],
        email: json["email"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "ci": ci,
        "name": name,
        "telefono": telefono,
        "email": email,
        "uuid": uuid,
      };
}

// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String? usuarioToJson(Usuario? data) => data != null ? json.encode(data.toJson()) : null;

class Usuario {
  String id;
  String? displayName;
  String? email;
  String? photoUrl;
  
  Usuario({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });


  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    email: json["email"] == null ? null : json["email"],
    photoUrl: json["photoURL"] == null ? null : json["photoURL"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayName": displayName == null ? null : displayName,
    "photoURL": photoUrl == null ? null : photoUrl,
    "email": email == null ? null : email,
  };
}

import 'dart:convert';

import 'package:precavidos_simulador/src/models/comentario_model.dart';

ComentarioUnResponse comentarioUnResponseFromJson(String str) => ComentarioUnResponse.fromJson(json.decode(str));

String comentarioUnResponseToJson(ComentarioUnResponse data) => json.encode(data.toJson());

class ComentarioUnResponse {
  ComentarioUnResponse({
    required this.ok,
    required this.comentario,
  });

  bool ok;
  Comentario comentario;

  factory ComentarioUnResponse.fromJson(Map<String, dynamic> json) => ComentarioUnResponse(
    ok: json["ok"],
    comentario: Comentario.fromJson(json["comentario"]),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "comentario": comentario.toJson(),
  };
}

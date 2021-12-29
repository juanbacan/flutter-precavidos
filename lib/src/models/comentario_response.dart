import 'dart:convert';

import 'package:precavidos_simulador/src/models/comentario_model.dart';

ComentarioResponse comentarioResponseFromJson(String str) => ComentarioResponse.fromJson(json.decode(str));

String comentarioResponseToJson(ComentarioResponse data) => json.encode(data.toJson());

class ComentarioResponse {
  ComentarioResponse({
    required this.ok,
    required this.comentarios,
  });

  bool ok;
  List<Comentario?> comentarios;

  factory ComentarioResponse.fromJson(Map<String, dynamic> json) => ComentarioResponse(
    ok: json["ok"],
    comentarios: List<Comentario?>.from(json["comentarios"].map((x) => Comentario.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "comentarios": List<dynamic>.from(comentarios.map((x) => x?.toJson())),
  };
}

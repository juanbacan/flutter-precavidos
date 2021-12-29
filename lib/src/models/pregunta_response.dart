// To parse this JSON data, do
//
//     final preguntaResponse = preguntaResponseFromJson(jsonString);

import 'dart:convert';

import 'package:precavidos_simulador/src/models/comentario_model.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';

PreguntaResponse preguntaResponseFromJson(String str) => PreguntaResponse.fromJson(json.decode(str));

String preguntaResponseToJson(PreguntaResponse data) => json.encode(data.toJson());

class PreguntaResponse {
  PreguntaResponse({
    required this.ok,
    required this.pregunta,
    required this.comentarios,
  });

  bool ok;
  Pregunta pregunta;
  List<Comentario?> comentarios;

  factory PreguntaResponse.fromJson(Map<String, dynamic> json) => PreguntaResponse(
    ok: json["ok"],
    pregunta: Pregunta.fromJson(json["pregunta"]),
    comentarios: List<Comentario?>.from(json["comentarios"].map((x) => Comentario.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "pregunta": pregunta.toJson(),
    "comentarios": List<dynamic>.from(comentarios.map((x) => x?.toJson())),
  };
}

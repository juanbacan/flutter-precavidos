import 'dart:convert';

import 'package:precavidos_simulador/src/models/pregunta.dart';

PreguntasResponse preguntasResponseFromJson(String str) => PreguntasResponse.fromJson(json.decode(str));

String preguntasResponseToJson(PreguntasResponse data) => json.encode(data.toJson());

class PreguntasResponse {
  
    bool? ok;
    List<Pregunta>? preguntas;

  PreguntasResponse({
      this.ok,
      this.preguntas,
    });


    factory PreguntasResponse.fromJson(Map<String, dynamic> json) => PreguntasResponse(
        ok: json["ok"],
        preguntas: json["preguntas"] != null ? List<Pregunta>.from(json["preguntas"].map((x) => Pregunta.fromJson(x))) : null,
    );

    Map<String, dynamic> toJson() => {
        "ok": ok != null ? ok : false,
        "preguntas": preguntas != null ? List<dynamic>.from(preguntas!.map((x) => x.toJson())) : null,
    };
}
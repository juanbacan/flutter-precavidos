
import 'dart:convert';

import 'package:precavidos_simulador/src/models/comentario_model.dart';

Pregunta preguntaFromJson(String str) => Pregunta.fromJson(json.decode(str));

String preguntaToJson(Pregunta data) => json.encode(data.toJson());

class Pregunta {

  bool? aprobada;
  List<Comentario?>? comentarios;
  List<String>? likes;
  int? creado;
  bool? simulador;
  bool? simulador2;
  bool? simulador3;
  String tipo;
  String uid;
  List<String>? categorias;
  String respuestaCorrecta;
  String enunciado;
  Respuestas respuestas;
  String? nombre;
  String id;

  Pregunta({
    this.aprobada,
    this.comentarios,
    this.likes,
    this.creado,
    this.simulador,
    this.simulador2,
    this.simulador3,
    this.categorias,
    this.nombre,
    required this.id,
    required this.tipo,
    required this.uid,
    required this.respuestaCorrecta,
    required this.enunciado,
    required this.respuestas,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
    aprobada: json["aprobada"],
    //comentarios: List<Comentario>.from(json["comentarios"].map((x) => Comentario.fromJson(x))),
    comentarios: json["comentarios"] != null ? List<Comentario>.from(json["comentarios"]?.map((x) => Comentario.fromJson(x))) : null,
    likes: json["likes"] != null ? List<String>.from(json["likes"]?.map((x) => x)) : null,
    creado: json["creado"],
    simulador: json["simulador"],
    simulador2: json["simulador2"],
    simulador3: json["simulador3"],
    tipo: json["tipo"],
    uid: json["uid"],
    categorias: json["categorias"] != null ? List<String>.from(json["categorias"]!.map((x) => x)) : null,
    respuestaCorrecta: json["respuestaCorrecta"],
    enunciado: json["enunciado"],
    respuestas: Respuestas.fromJson(json["respuestas"]),
    nombre: json["nombre"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "aprobada": aprobada,
    "comentarios": comentarios != null ? List<dynamic>.from(comentarios!.map((x) => x?.toJson())) : null,
    "likes": likes != null ? List<String>.from(likes!.map((x) => x)) : null,
    "creado": creado,
    "simulador": simulador,
    "simulador2": simulador2,
    "simulador3": simulador3,
    "tipo": tipo,
    "uid": uid,
    "categorias": categorias != null ? List<String>.from(categorias!.map((x) => x)) : null,
    "respuestaCorrecta": respuestaCorrecta,
    "enunciado": enunciado,
    "respuestas": respuestas.toJson(),
    "nombre": nombre,
    "id": id,
  };
}



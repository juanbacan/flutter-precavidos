// To parse this JSON data, do
//
//     final infoUserResponse = infoUserResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

InfoUserResponse infoUserResponseFromJson(String str) => InfoUserResponse.fromJson(json.decode(str));

String infoUserResponseToJson(InfoUserResponse data) => json.encode(data.toJson());

class InfoUserResponse {

  String? msg;
  bool? ok;
  ListaSimuladores? simuladores;
  ListaSimuladores? simuladores2;
  ListaSimuladores? simuladores3;

  InfoUserResponse({
    this.msg,
    this.ok,
    this.simuladores,
    this.simuladores2,
    this.simuladores3,
  });

  factory InfoUserResponse.fromJson(Map<String, dynamic> json) => InfoUserResponse(
    msg: json["msg"],
    ok: json["ok"],
    simuladores: json["simuladores"] != null ? ListaSimuladores.fromJson(json["simuladores"]) : null,
    simuladores2: json["simuladores2"] != null ? ListaSimuladores.fromJson(json["simuladores2"]) : null,
    simuladores3: json["simuladores3"] != null ? ListaSimuladores.fromJson(json["simuladores3"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "ok": ok != null ? ok : false,
    "simuladores": simuladores != null ? simuladores!.toJson() : null,
    "simuladores2": simuladores2 != null ? simuladores2!.toJson() : null,
    "simuladores3": simuladores3 != null ? simuladores3!.toJson() : null,
  };
}

class ListaSimuladores {

  List<Simulacion>? numerico;
  List<Simulacion>? abstracto;
  List<Simulacion>? logico;
  List<Simulacion>? verbal;

  ListaSimuladores({
    this.numerico,
    this.abstracto,
    this.logico,
    this.verbal,
  });

  factory ListaSimuladores.fromJson(Map<String, dynamic> json) => ListaSimuladores(
    numerico: json["numerico"] != null ? List<Simulacion>.from(json["numerico"].map((x) => Simulacion.fromJson(x))) : null,
    abstracto: json["abstracto"] != null ? List<Simulacion>.from(json["abstracto"].map((x) => Simulacion.fromJson(x))) : null,
    logico: json["logico"] != null ? List<Simulacion>.from(json["logico"].map((x) => Simulacion.fromJson(x))) : null,
    verbal: json["verbal"] != null ? List<Simulacion>.from(json["abstracto"].map((x) => Simulacion.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {    
    "numerico": numerico != null ? List<dynamic>.from(numerico!.map((x) => x.toJson())) : null,
    "abstracto": abstracto != null ? List<dynamic>.from(abstracto!.map((x) => x.toJson())) : null,
    "logico": logico != null ? List<dynamic>.from(logico!.map((x) => x.toJson())) : null,
    "verbal": verbal != null ? List<dynamic>.from(verbal!.map((x) => x.toJson())) : null,   
  };
}

class Simulacion {
  int fecha;
  List<InfoSimulacion> preguntas;
  int puntaje;

  Simulacion({
    required this.fecha,
    required this.preguntas,
    required this.puntaje,
  });

  factory Simulacion.fromJson(Map<String, dynamic> json) => Simulacion(
    fecha: json["fecha"],
    preguntas: List<InfoSimulacion>.from(json["preguntas"].map((x) => InfoSimulacion.fromJson(x))),
    puntaje: json["puntaje"],
  );

  Map<String, dynamic> toJson() => {
    "fecha": fecha,
    "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
    "puntaje": puntaje,
  };
}



  //const name({Key? key}) : super(key: key);


class InfoSimulacion {
  String id;
  String? userRespuesta;
  
  InfoSimulacion({
    required this.id,
    this.userRespuesta,
  });


  factory InfoSimulacion.fromJson(Map<String, dynamic> json) => InfoSimulacion(

    id: json["id"] == null ? null : json["id"],
    userRespuesta: json["userRespuesta"] == null ? null : json["userRespuesta"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userRespuesta": userRespuesta == null ? null : userRespuesta,
  };
}


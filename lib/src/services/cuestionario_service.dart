
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/models/preguntas_response.dart';

class CuestionarioService with ChangeNotifier {

  int _numPreguntas = 0;
  Map<String, String> _userResponses = {};
  Map<String, String> get userResponses => this._userResponses;

  // Guardar Información del Simulador
  // materia, curso, nivel
  String _materia = "";
  String _curso = "basico";
  int? _nivel = 1;

  set materia (String value) {
    this._materia = value;
  }
  set curso (String value) {
    this._curso = value;
  }
  set nivel (int value) {
    this._nivel = value;
  }

  void guardarSimulacion (String tokenUser) async {

    if (this._curso == "avanzado") return;

    final preguntas = [];

    final idsPreguntas = this._userResponses.keys;

    for (String idPregunta in idsPreguntas) {
      preguntas.add({
        "id" : idPregunta,
        "userRespuesta" : _userResponses[idPregunta]
      });
    }
    print(preguntas);

    await http.put(
      Uri.parse("${ Environment.apiURL }/infousuario"),
      headers: {
        'Content-Type': 'application/json',
        'x-token': tokenUser
      },
      body: json.encode(
        {
          "preguntas": preguntas,
          "materia": this._materia,
          "simulador": this._nivel.toString(),
          "puntaje": this._puntaje
        }
      )
    );
  }

  // ******************************************************************

  // ******************************************************************
  
  bool _mostrarResultado = false;
  bool get mostrarResultado => this._mostrarResultado;

  // Puntaje del simulador
  int _puntaje = 0;
  int get puntaje => this._puntaje;
  set puntaje (int value){
    this._puntaje = value;
    notifyListeners();
  }
  // ******************************************************************

  // Si la pregunta ha sido contestada
  bool _preguntaContestada = false;
  bool get preguntaContestada => this._preguntaContestada;
  set preguntaContestada ( bool value ) {
    this._preguntaContestada = value;
    notifyListeners();
  }
  // ******************************************************************

  // Pregunta actual mostrada
  int _preguntaActual = 0;
  int get preguntaActual => this._preguntaActual;

  set preguntaActual (int value){

    if(value >= this._numPreguntas-1){
      if(!this._mostrarResultado){
        this._preguntaActual = value;       // Cambia de pregunta
      }
      this._mostrarResultado = true;          // Las preguntas se acabaron se debe mostrar el resultado
      notifyListeners();
    } else{
      print(value >= this._numPreguntas);
      this._preguntaActual = value;       // Cambia de pregunta
      notifyListeners();
    }
  }

  List<Pregunta>? _preguntas;
  bool get existenPreguntas => this._preguntas != null ? true : false;
  List<Pregunta>? get preguntas => this._preguntas;
  set preguntas( List<Pregunta>? preguntas ) {
    this._preguntas = preguntas;                        // Configra las preguntas en un array
    this._numPreguntas = preguntas!.length;             // Configura el número de preguntas
    notifyListeners();
  }

  // Realiza la consulta de las preguntas
  Future<List<Pregunta>?> getPreguntas( String materia, String curso, [nivel] ) async {

    if(curso == "avanzado"){
      try {

        final resp = await http.get(Uri.parse("${ Environment.apiURL }/categorias/simulador?categoria=$materia"),
          headers: {
            'Content-Type': 'application/json',
          }
        );

        final preguntasResponse = preguntasResponseFromJson( resp.body );

        return preguntasResponse.preguntas;
      } catch (e) {
        print("Ha fallado la consulta");
        return [];
      }
    } else if(curso == "basico"){
      try {
        final resp = await http.get(Uri.parse("${ Environment.apiURL }/simulador/$materia?simulador=$nivel"),
          headers: {
            'Content-Type': 'application/json',
          }
        );

        final preguntasResponse = preguntasResponseFromJson( resp.body );
        return preguntasResponse.preguntas;
      } catch (e) {
        print("Ha fallado la consulta");
        return [];
      }
    }
  }


}
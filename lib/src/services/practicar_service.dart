import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/models/preguntas_response.dart';



class PracticarService with ChangeNotifier {

  // Pregunta contestada
  bool _preguntaContestada = false;
  bool get preguntaContestada => this._preguntaContestada;
  set preguntaContestada (bool value){
    this._preguntaContestada = value;
    notifyListeners();
  }

  // ******************************************************************
  int _numPreguntas = 0;
  int get numPreguntas => this._numPreguntas;

  List<Pregunta>? _preguntas;
  bool get existenPreguntas => this._preguntas != null ? true : false;
  List<Pregunta>? get preguntas => this._preguntas;
  set preguntas( List<Pregunta>? preguntas ) {
    this._preguntas = preguntas;                        // Configra las preguntas en un array
    this._numPreguntas = preguntas!.length;             // Configura el número de preguntas
    notifyListeners();
  }
  // ******************************************************************


  // Realiza la consulta de las preguntas
  Future<List<Pregunta>?> getPreguntas( String materia ) async {

    print(materia);

    try {
      final resp = await http.get(Uri.parse("${ Environment.apiURL }/simulador/aleatorio/$materia?num=20"),
      //final resp = await http.get(Uri.parse("${ Environment.apiURL }/simulador/aleatorio/atencion-y-concentracion?num=20"),
      //final resp = await http.get(Uri.parse("${ Environment.apiURL }/preguntas/todo/logico"),
      //final resp = await http.get(Uri.parse("${ Environment.apiURL }/preguntas/abstracto?desde=0"),
        headers: {
          'Content-Type': 'application/json',
        }
      );

      final preguntasResponse = preguntasResponseFromJson( resp.body );

      return preguntasResponse.preguntas;
    } catch (e) {
      print(e);
      return [];
    }
  }

}
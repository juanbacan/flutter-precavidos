import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/models/preguntas_response.dart';

class ContraRelojService with ChangeNotifier {

  // Guardado delas respuestas de los usaurios idPregunta, userRespuesta
  int _numPreguntas = 0;

  Map<String, String> _userResponses = {};
  Map<String, String> get userResponses => this._userResponses;

  bool _mostrarResultado = false;
  bool get mostrarResultado => this._mostrarResultado;
  

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
    if(value >= this._numPreguntas){
      this._cancelarTimer = true;
      this._mostrarResultado = true;          // Las preguntas se acabaron se debe mostrar el resultado
    } else{
      this._preguntaActual = value;       // Cambia de pregunta
      notifyListeners();
    }
  }
  // ******************************************************************

  // Puntaje del simulador
  int _puntaje = 0;
  int get puntaje => this._puntaje;
  set puntaje (int value){
    this._puntaje = value;
    notifyListeners();
  }
  // ******************************************************************

  // Si se detiene el Timer
  bool _cancelarTimer = false;
  bool get cancelarTimer => this._cancelarTimer;
  set cancelarTimer (bool value){
    this._cancelarTimer = value;
    notifyListeners();
  }
  // ******************************************************************

  bool _consultando = false;
  bool get consultando => this._consultando;

  
  // ******************************************************************
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
  Future<List<Pregunta>?> getPreguntas(String materia) async {
    
    this._consultando = true;
    try {
      final resp = await http.get(Uri.parse("${ Environment.apiURL }/simulador/aleatorio/$materia?num=15"),
        headers: {
          'Content-Type': 'application/json',
        }
      );

      final preguntasResponse = preguntasResponseFromJson( resp.body );

      this._consultando = false;
      return preguntasResponse.preguntas;
    } catch (e) {
      print("Ha fallado la consulta");
      this._consultando = false;
      return [];
    }
  }

}
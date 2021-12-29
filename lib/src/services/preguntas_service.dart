import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/comentario_model.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/models/pregunta_response.dart';
import 'package:precavidos_simulador/src/models/preguntas_response.dart';

class PreguntasService with ChangeNotifier {

  // Para evitar presinar el botón varias veces
  bool _consultando = false;
  bool get consultando => this._consultando;
  set consultando (bool value){
    this._consultando = value;
    notifyListeners();
  }

  // Para actualizar los comentarios cuando se agrega uno nuevo
  List<Comentario?>? _comentarios = [];

  List<Comentario?>? get comentarios => this._comentarios;

  set comentarios (List<Comentario?>? value){
    this._comentarios = value;
    notifyListeners();
  }

  Future <Pregunta?> getPreguntaById(String preguntaId) async{

    try {
      final resp = await http.get(
        Uri.parse("${ Environment.apiURL }/pregunta/$preguntaId"),
        headers: {
          'Content-Type': 'application/json',
        }
      );

      final preguntaResponse = preguntaResponseFromJson( resp.body );

      preguntaResponse.pregunta.comentarios = preguntaResponse.comentarios;

      // Los comentarios son globales al crearse o eliminarse un comentario
      this._comentarios = preguntaResponse.comentarios;
      notifyListeners();

      return preguntaResponse.pregunta;

    } catch (e) {
      print("Error!!!!!!!!!!!!!!!11");
      print(e);  
      //notifyListeners();
      return null;    
    }  
  }

  void actualizarComentarios(Comentario comentario) {
    print("Actualizando comentarios");

    try {
      int? comentarioActualizado = this._comentarios?.indexWhere((Comentario? element) => element?.id == comentario.id);
      this._comentarios![comentarioActualizado!] = comentario;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future <List<Pregunta>?> getPreguntasById(List<String> preguntasId) async {
    
    this._consultando = true;
    notifyListeners();

    try {
      final resp = await http.post(
        Uri.parse("${ Environment.apiURL }/simulador/preguntas/byid"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "preguntasId": preguntasId
        })
      );

      final preguntasResponse = preguntasResponseFromJson( resp.body );

      this._consultando = false;
      notifyListeners();

      return preguntasResponse.preguntas;

    } catch (e) {
      print("Error!!!!!!!!!!!!!!!11");
      print(e);  
      this._consultando = false;
      //notifyListeners();
      return null;    
    }    
  }

}
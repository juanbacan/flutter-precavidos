import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/pages/resultado_page.dart';
import 'package:precavidos_simulador/src/widgets/opcion.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/services/contra_reloj_service.dart';

class OpcionSimulador extends StatefulWidget {
  const OpcionSimulador({
    Key? key,
    required this.opcion,
    required this.respuestaCorrecta,
    required this.numOpcion
  }) : super(key: key);

  final String opcion;
  final String respuestaCorrecta;
  final String numOpcion;

  @override
  _OpcionState createState() => _OpcionState();
}

class _OpcionState extends State<OpcionSimulador> {

  bool correcta = false;
  bool contestada = false;

  @override
  Widget build(BuildContext context) {

    final simuladorService = Provider.of<ContraRelojService>(context, listen: false);

    void mainFunction(){
      if(simuladorService.preguntaContestada == true) return;   // Si la pregunta ya fue contestada

      simuladorService.preguntaContestada = true;     // Se está contestando ahora
      contestada = true;

      // Guarda las respuestas contestadas por el usuario
      String idPregunta = simuladorService.preguntas![simuladorService.preguntaActual].id;
      simuladorService.userResponses["$idPregunta"] = "${widget.numOpcion}";

      if( widget.respuestaCorrecta == widget.numOpcion ){ // Se contesta correctamente
        correcta = true;
        simuladorService.puntaje ++;                  // Incrementa en 1 el puntaje
      }
      setState(() {});

      simuladorService.cancelarTimer = true;          // Cancela el contador

      Future.delayed(Duration(seconds: 2), () {
        if(mounted){
          if (simuladorService.mostrarResultado == true){ // Se debe mostrar el resultado, se acabaron las preguntas

            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => ResultadoPage(preguntas: simuladorService.preguntas!, userResponses: simuladorService.userResponses))
            );

          } else{
            correcta = false;
            contestada = false;                           // La siguiente pregunta comienza con el estado no contestada
            simuladorService.preguntaContestada = false;  // Cambia de pregunta y reinicia el estado de contestada
            simuladorService.preguntaActual ++;           // Cambia a la siguiente pregunta
          }  
        }        
      });
    } 

    return Opcion(contestada: contestada, correcta: correcta, enunciado: widget.opcion, onPressed: mainFunction);
  }
}
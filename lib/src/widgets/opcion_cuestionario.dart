import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/widgets/opcion.dart';
import 'package:precavidos_simulador/src/pages/resultado_page.dart';
import 'package:precavidos_simulador/src/services/cuestionario_service.dart';

class OpcionCuestionario extends StatefulWidget {
  const OpcionCuestionario({
    Key? key,
    required this.enunciado,
    required this.respuestaCorrecta,
    required this.numOpcion,
    this.onPressed
  }) : super(key: key);

  final String enunciado;
  final String respuestaCorrecta;
  final String numOpcion;
  final VoidCallback? onPressed;

  @override
  __OpcionState createState() => __OpcionState();
}

class __OpcionState extends State<OpcionCuestionario> {

  bool correcta = false;
  bool contestada = false;

  @override
  Widget build(BuildContext context) {

    final cuestionarioService = Provider.of<CuestionarioService>(context, listen: false);
    final _authService = Provider.of<AuthService>(context);

    void mainFunction(){
      if(cuestionarioService.preguntaContestada == true) return;   // Si la preugnta ya fue contestada

      cuestionarioService.preguntaContestada = true;     // Se está contestando ahora
      contestada = true;

      // Guarda las respuestas contestadas por el usuario
      String idPregunta = cuestionarioService.preguntas![cuestionarioService.preguntaActual].id;
      cuestionarioService.userResponses["$idPregunta"] = "${widget.numOpcion}";

      if( widget.respuestaCorrecta == widget.numOpcion ){ // Se contesta correctamente
        correcta = true;
        cuestionarioService.puntaje ++;                  // Incrementa en 1 el puntaje
      }
      setState(() {});

      Future.delayed(Duration(milliseconds: 500), () async{
        if(mounted){
          //print(cuestionarioService);
          if (cuestionarioService.mostrarResultado == true){ // Se debe mostrar el resultado, se acabaron las preguntas
            
            // Guarda la simulación
            
            final tokenUser =  await _authService.getTokenUser();

            // Solo guarda los datos si hay un usuario
            if(tokenUser != "No hay Token"){
              cuestionarioService.guardarSimulacion(tokenUser);
            } 
            
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => ResultadoPage(preguntas: cuestionarioService.preguntas!, userResponses: cuestionarioService.userResponses))
            );

          } else{
            widget.onPressed!();
            correcta = false;
            contestada = false;                           // La siguiente pregunta comienza con el estado no contestada
            cuestionarioService.preguntaContestada = false;  // Cambia de pregunta y reinicia el estado de contestada
            cuestionarioService.preguntaActual ++;           // Cambia a la siguiente pregunta
          }  
        }        
      });
    } 

    return Opcion(
      contestada: contestada, 
      correcta: correcta, 
      enunciado: widget.enunciado,
      onPressed: mainFunction,
    );
  }
}

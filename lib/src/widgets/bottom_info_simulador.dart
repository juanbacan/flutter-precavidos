import 'dart:async';

import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/pages/resultado_page.dart';
import 'package:precavidos_simulador/src/services/contra_reloj_service.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:provider/provider.dart';

class BottomInfo extends StatefulWidget {
  
  @override
  _BottomInfoState createState() => _BottomInfoState();
}

class _BottomInfoState extends State<BottomInfo> {

  static const maxSeconds = 25;
  bool disableNextQuestion = false;
  int seconds = maxSeconds;
  Timer? timer;
  ContraRelojService? simuladorService;

  @override
  void initState() {
    this.simuladorService = Provider.of<ContraRelojService>(context, listen: false);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), ( _ ) {

      setState(() {
        if (seconds < 1) {
          timer?.cancel();
          nextQuestion();
        } else if (this.simuladorService?.cancelarTimer == true) {    // Se cambio de pregunta o se acabaron las preguntas
          timer?.cancel();
          nextQuestionWithDelay();
        } else {
          seconds --;
        }
      });
    });
  }

  void nextQuestionWithDelay() {
    timer?.cancel();
    this.simuladorService?.cancelarTimer = false;
    setState(() {disableNextQuestion = true;});
    Future.delayed(Duration(seconds: 2), () {
      seconds = maxSeconds;
      if(mounted){
        if (this.simuladorService?.mostrarResultado == true){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => ResultadoPage(preguntas: this.simuladorService!.preguntas!, userResponses: this.simuladorService!.userResponses))
          );
        }else{
          startTimer();
          setState(() {disableNextQuestion = false;});   
        }
      }
    });
  }

  void nextQuestion() {
    timer?.cancel();
    this.simuladorService?.cancelarTimer = false;   
    this.simuladorService?.preguntaActual ++;
    seconds = maxSeconds;
    if (this.simuladorService?.mostrarResultado == true){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => ResultadoPage(preguntas: this.simuladorService!.preguntas!, userResponses: this.simuladorService!.userResponses))
      );
      print("Mostrar el resultado");
    }else{
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {

    int? puntaje = this.simuladorService?.puntaje;

    return Container(
      height: 70,
      width: double.maxFinite,
      decoration: BoxDecoration(

      color: MyColors.primaryColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Puntaje", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(puntaje.toString(), style: TextStyle(color: Colors.white))
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(child: CircularProgressIndicator(
                value: ((seconds-maxSeconds)*100/maxSeconds).abs()/100,
                color: Colors.white,
              )),
              Center(child: Text("$seconds", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white), 
                onPressed: (!disableNextQuestion)
                  ? (){ nextQuestion(); }
                  : null
              ),
            ],
          ),
        ],
      ),
    );
  }
}
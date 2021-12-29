import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/pages/respuestas_page.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';

class ResultadoPage extends StatefulWidget {

  final List<Pregunta> preguntas; 
  final Map<String, String> userResponses;

  const ResultadoPage({
    required this.preguntas,
    required this.userResponses
  });

  @override
  _ResultadoPageState createState() => _ResultadoPageState();
}

class _ResultadoPageState extends State<ResultadoPage> {

  @override
  Widget build(BuildContext context) {

    int puntaje = 0;

    Iterable<String> preguntasRespondidas = widget.userResponses.keys;

    // Calculo del puntaje
    for (var pregunta in widget.preguntas) {
      if(preguntasRespondidas.contains(pregunta.id)){
        if(pregunta.respuestaCorrecta == widget.userResponses[pregunta.id]){
          puntaje ++;
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                          
                    AppBarPrecavidos(titulo: "Resultado", color: Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                          
                    Container(
                      margin: EdgeInsets.only(right: 30, bottom: 50),
                      width: 160,
                      child: Image(image: AssetImage('assets/images/Awesome.png'))
                    ),
                    Text("TU PUNTAJE:"),
                    SizedBox(height: 10),
                    Text("$puntaje/${widget.preguntas.length}", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                          
                    SizedBox(height: 40),
                          
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_ios_new, color: Colors.black),
                                SizedBox(width: 10),
                                Text("Regresar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
                              ],
                            ),
                          ),
                        ),
              
                        SizedBox(width: 20),
              
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => RespuestasPage(preguntas: widget.preguntas, userResponses: widget.userResponses))
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_copy_sharp, color: Colors.white),
                                SizedBox(width: 10),
                                Text("Respuestas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            BannerAdGoogle(),
          ],
        ),
      ),
    );
  }
}
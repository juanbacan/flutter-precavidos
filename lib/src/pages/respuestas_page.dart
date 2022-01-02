import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/comentario_model.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/pages/pregunta_page.dart';
//import 'package:precavidos_simulador/src/pages/responder_page.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';


class RespuestasPage extends StatelessWidget {

  final List<Pregunta> preguntas; 
  final Map<String, String> userResponses;

  const RespuestasPage({
    required this.preguntas,
    required this.userResponses
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _Resultado(preguntas: preguntas, userResponses: userResponses),  
      ),
    );
  }
}

class _Resultado extends StatefulWidget {
  
  final List<Pregunta> preguntas;
  final Map<String, String> userResponses;  

  const _Resultado({
    required this.preguntas,
    required this.userResponses,
  });

  @override
  __ResultadoState createState() => __ResultadoState();
}

class __ResultadoState extends State<_Resultado> {

  int numPreguntaActual = 0;

  @override
  Widget build(BuildContext context) {

    Pregunta preguntaActual = widget.preguntas[numPreguntaActual];
    Respuestas respuestas = preguntaActual.respuestas;
    
    String respuestaCorrecta = preguntaActual.respuestaCorrecta;
    
    return Column(
      children: [

        AppBarPrecavidos(titulo: "Respuestas", color: Theme.of(context).primaryColor),

        SizedBox(height: 30),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Escoge la pregunta", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          width: double.infinity,
          height: 30,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.preguntas.length,
            itemBuilder: (BuildContext context, int index){

              Pregunta pregunta = widget.preguntas[index];

              return GestureDetector(
                onTap: (){               
                  setState(() {
                    numPreguntaActual = index;
                  });
                },
                child: Container(
                  width: 35,
                  color: (numPreguntaActual == index) 
                    ? MyColors.selected 
                    : (widget.userResponses.keys.contains(pregunta.id))
                      ? (widget.userResponses[pregunta.id] == pregunta.respuestaCorrecta)
                        ? MyColors.correct
                        : MyColors.incorrect
                    : MyColors.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Center(child: 
                    Text((index+1).toString(), style: TextStyle(color: Colors.white))
                  )
                ),
              );
            },
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only( bottom: 50, top: 20 ),
              child: Column(
                children: [
                  Html(data: preguntaActual.enunciado),
                  _Opcion(
                    enunciado: respuestas.respuesta1, 
                    numRespuesta: "respuesta1",
                    respuestaCorrecta: respuestaCorrecta,
                    userRespuesta: (widget.userResponses.keys.contains(preguntaActual.id))
                      ? widget.userResponses[preguntaActual.id]
                      : null
                  ),
                  _Opcion(
                    enunciado: respuestas.respuesta2, 
                    numRespuesta: "respuesta2",
                    respuestaCorrecta: respuestaCorrecta,
                    userRespuesta: (widget.userResponses.keys.contains(preguntaActual.id))
                      ? widget.userResponses[preguntaActual.id]
                      : null
                  ),
                  _Opcion(
                    enunciado: respuestas.respuesta3, 
                    numRespuesta: "respuesta3",
                    respuestaCorrecta: respuestaCorrecta,
                    userRespuesta: (widget.userResponses.keys.contains(preguntaActual.id))
                      ? widget.userResponses[preguntaActual.id]
                      : null
                  ),
                  _Opcion(
                    enunciado: respuestas.respuesta4, 
                    numRespuesta: "respuesta4",
                    respuestaCorrecta: respuestaCorrecta,
                    userRespuesta: (widget.userResponses.keys.contains(preguntaActual.id))
                      ? widget.userResponses[preguntaActual.id]
                      : null
                  ),
                ],
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => PreguntaPage(preguntaId: preguntaActual.id)
                  )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text("¿COMO RESOLVER?", 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, )
                )
              ),
            )
          ],
        ),
        
        BannerAdGoogle()
      ],
    );
  }
}

class _Opcion extends StatelessWidget {

  final String enunciado;
  final numRespuesta;
  final String? userRespuesta;
  final String respuestaCorrecta;

  const _Opcion({
    required this.enunciado,
    required this.numRespuesta,
    this.userRespuesta,
    required this.respuestaCorrecta,
  });

  @override
  Widget build(BuildContext context) {

    final Map<ImageSourceMatcher, ImageRender> defaultImageRenders = {
      assetUriMatcher(): assetImageRender(),
      networkSourceMatcher(extension: "svg"): svgNetworkImageRender(),
      networkSourceMatcher(): networkImageRender(width: 100),
    };

    return Container(
      margin: EdgeInsets.symmetric( vertical: 5 ),
      padding: EdgeInsets.symmetric( vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (this.numRespuesta == this.respuestaCorrecta)
            ? MyColors.correct
            : (this.userRespuesta == null)
              ? MyColors.primaryColor
              : (this.userRespuesta == this.numRespuesta)
                ? MyColors.incorrect
                : MyColors.primaryColor,
          width: 2.5
        )
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Html(
              data: enunciado,
              customImageRenders: defaultImageRenders,
            ),
          ),
        ],
      )
    );
  }
}
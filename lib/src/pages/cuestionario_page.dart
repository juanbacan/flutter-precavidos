import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/widgets/html_table.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPreguntas.dart';
import 'package:precavidos_simulador/src/widgets/opcion_cuestionario.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/services/cuestionario_service.dart';


class CuestionarioPage extends StatelessWidget {
  const CuestionarioPage({required this.materia, required this.curso, this.nivel});

  final Materia materia;
  final String curso;
  final int? nivel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, size: 30, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 10),
                Text("Aviso")
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("¿Estás seguro de que quieres parar el simulador?"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [       
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context, true);
                    }, child: Text("Si")),
                    SizedBox(width: 20),
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context, false);
                    }, child: Text("No"))
                  ],
                ) 
              ]
            )
          ),
        )) ?? false;
      },
      child: ChangeNotifierProvider(
        create: ( _ ) => new CuestionarioService(),
        child: Scaffold(
          body: SafeArea(
            child: _Cuestionario(materia: this.materia, curso: this.curso, nivel: this.nivel),
          ),
        ),
      ),
    );
  }
}

class _Cuestionario extends StatefulWidget {
  _Cuestionario({required this.materia, required this.curso, this.nivel});
  final Materia materia;
  final String curso;
  final int? nivel;

  @override
  __CuestionarioState createState() => __CuestionarioState();
}

final itemSize = 30.0;

class __CuestionarioState extends State<_Cuestionario> {

  List<Pregunta>? preguntas = [];
  ScrollController? _controller;

  @override
  void initState() {
    _controller = ScrollController();
    this._cargarPreguntas();
    this._guardarInfoSimulador();
    super.initState();
  }

  @override
  void dispose() { 
    _controller?.dispose();
    super.dispose();
  }

  void _guardarInfoSimulador () async {
    final cuestionarioService = Provider.of<CuestionarioService>(context, listen: false);
    cuestionarioService.curso = widget.curso;
    cuestionarioService.materia = widget.materia.url;

    if (widget.nivel != null){
      cuestionarioService.nivel = widget.nivel!;
    }
  }

  void _cargarPreguntas () async {

    final cuestionarioService = Provider.of<CuestionarioService>(context, listen: false);
    this.preguntas = await cuestionarioService.getPreguntas( widget.materia.url, widget.curso, widget.nivel );
    cuestionarioService.preguntas = preguntas;
  }

  @override
  Widget build(BuildContext context) {

    final cuestionarioService = Provider.of<CuestionarioService>(context);
    

    Pregunta? pregunta = cuestionarioService.preguntas?[cuestionarioService.preguntaActual];
  

    void animationNextQuestion(){
      double widthScreen = MediaQuery.of(context).size.width;
      int numPregunta = cuestionarioService.preguntaActual;
      _controller?.animateTo((widthScreen < numPregunta * 50) ? _controller!.offset + 50: 0,
      curve: Curves.linear, duration: Duration(milliseconds: 200));
    }

    return (!cuestionarioService.existenPreguntas)
      ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          AppBarPreguntas(
            titulo: "${widget.materia.name}", 
            preguntaActual: cuestionarioService.preguntaActual, 
            numPreguntas: cuestionarioService.preguntas!.length,
            alertDialog: true,
          ),

          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 30,
            child: ListView.builder(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: cuestionarioService.preguntas!.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  width: 35,
                  color: (cuestionarioService.preguntaActual == index) 
                    ? MyColors.selected 
                    : MyColors.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Center(child: 
                    Text((index+1).toString(), style: TextStyle(color: Colors.white))
                  )
                );
              },
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: _PreguntaDetalle(
                pregunta: pregunta!, 
                onPressed: animationNextQuestion
              )
            ),
          ),
        ],
      ); 
  }  
}

class _PreguntaDetalle extends StatelessWidget {
    
  final Pregunta pregunta;
  final VoidCallback? onPressed;

  const _PreguntaDetalle({ required this.pregunta, this.onPressed });
  
    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only( bottom: 50 ),
          child: Column(
            children: [
              HtmlTable(data: pregunta.enunciado),
              SizedBox(height: 20),
              OpcionCuestionario(
                enunciado: pregunta.respuestas.respuesta1, 
                respuestaCorrecta: pregunta.respuestaCorrecta, 
                numOpcion: "respuesta1",
                onPressed: onPressed,

              ),
              OpcionCuestionario(
                enunciado: pregunta.respuestas.respuesta2, 
                respuestaCorrecta: pregunta.respuestaCorrecta, 
                numOpcion: "respuesta2",
                onPressed: onPressed,
              ),
              OpcionCuestionario(
                enunciado: pregunta.respuestas.respuesta3, 
                respuestaCorrecta: pregunta.respuestaCorrecta, 
                numOpcion: "respuesta3",
                onPressed: onPressed,
              ),
              OpcionCuestionario(
                enunciado: pregunta.respuestas.respuesta4, 
                respuestaCorrecta: pregunta.respuestaCorrecta, 
                numOpcion: "respuesta4",
                onPressed: onPressed,
              ),
            ]
          ),
        ),
      );
    }
  }
  

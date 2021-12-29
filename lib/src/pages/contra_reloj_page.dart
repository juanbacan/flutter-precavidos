import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:precavidos_simulador/src/widgets/appBarPreguntas.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/services/contra_reloj_service.dart';
import 'package:precavidos_simulador/src/widgets/bottom_info_simulador.dart';
import 'package:precavidos_simulador/src/widgets/opcion_simulador.dart';

class ContraRelojPage extends StatelessWidget {

  final Materia materia;

  const ContraRelojPage({Key? key, required this.materia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => new ContraRelojService(),
      child: Scaffold(
        body: SafeArea(child: Simulador(materia: this.materia)),
      )
    );
  }
}

class Simulador extends StatefulWidget {

  final Materia materia;

  const Simulador({
    required this.materia
  });

  @override
  _SimuladorState createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {

  List<Pregunta>? preguntas = [];

  @override
  void initState() {
    this._cargarPreguntas();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final simuladorService = Provider.of<ContraRelojService>(context);

    return (!simuladorService.existenPreguntas)
      ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          AppBarPreguntas(
            titulo: widget.materia.name, 
            preguntaActual: simuladorService.preguntaActual, 
            numPreguntas: simuladorService.preguntas!.length
          ),
          SizedBox(height: 20),
          Expanded(
            child: _PreguntaDetalle(pregunta: simuladorService.preguntas![simuladorService.preguntaActual]),
          ),

          BottomInfo()
        ],
      ); 
  }

  void _cargarPreguntas() async {
    final simuladorService = Provider.of<ContraRelojService>(context, listen: false);
    this.preguntas = await simuladorService.getPreguntas(widget.materia.url);
    simuladorService.preguntas = preguntas;
  }
}

class _PreguntaDetalle extends StatefulWidget {
  final Pregunta pregunta;
  const _PreguntaDetalle({ required this.pregunta });

  @override
  __PreguntaDetalleState createState() => __PreguntaDetalleState();
}

class __PreguntaDetalleState extends State<_PreguntaDetalle> {

  ScrollController _controller = ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.only( bottom: 50 ),
        child: Column(
          children: [
            Html(data: widget.pregunta.enunciado),
            SizedBox(height: 20),
            OpcionSimulador(opcion: widget.pregunta.respuestas.respuesta1, respuestaCorrecta: widget.pregunta.respuestaCorrecta, numOpcion: "respuesta1"),
            OpcionSimulador(opcion: widget.pregunta.respuestas.respuesta2, respuestaCorrecta: widget.pregunta.respuestaCorrecta, numOpcion: "respuesta2"),
            OpcionSimulador(opcion: widget.pregunta.respuestas.respuesta3, respuestaCorrecta: widget.pregunta.respuestaCorrecta, numOpcion: "respuesta3"),
            OpcionSimulador(opcion: widget.pregunta.respuestas.respuesta4, respuestaCorrecta: widget.pregunta.respuestaCorrecta, numOpcion: "respuesta4"),
          ],
        )
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';

import 'cuestionario_page.dart';

class CursoBasicoPage extends StatelessWidget {
  const CursoBasicoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<Materia> materias = [
      Materia("Razonamiento Numérico", 20, "simulador/facil.png", "numerico"),
      Materia("Razonamiento Lógico", 20, "simulador/facil.png", "logico"),
      Materia("Razonamiento Verbal", 20, "simulador/facil.png", "verbal"),
      Materia("Razonamiento Abstracto", 20, "simulador/facil.png", "abstracto"),
    ];

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    AppBarPrecavidos(titulo: "Curso Básico", color: MyColors.cursoBasico),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("Resuelve un cuestionario de preguntas por materia. Al finalizar el simulador se guardará tu progreso y o podrás revisar en la sección de Usuario."),
                          SizedBox(height: 10),
                          _Title(text: "Simulador Nivel 1"),
                          _MateriasCard(materias: materias, nivel: 1),
                          _Title(text: "Simulador Nivel 2"),
                          _MateriasCard(materias: materias, nivel: 2),
                          _Title(text: "Simulador Nivel 3"),
                          _MateriasCard(materias: materias, nivel: 3),
                          SizedBox(height: 20)
                        ],
                      ),
                    )
                  ],
                )     
              ),
            ),
            SizedBox(height: 20),
            BannerAdGoogle()
          ],
        ),
      )
    );
  }
}

class _Title extends StatelessWidget {

  final String text;

  const _Title({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:20, bottom: 20),
      child: Text(text,             
        style: Theme.of(context).textTheme.headline6
      ),
    );
  }
}

class _MateriasCard extends StatelessWidget {
  const _MateriasCard({
    Key? key,
    required this.materias,
    required this.nivel,
  }) : super(key: key);

  final List<Materia> materias;
  final int nivel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: materias.length,
        itemBuilder: (BuildContext context, int index){

          final materia = materias[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.cursoBasicoLight,
            ),
            width: 300,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CuestionarioPage(materia: materia, curso: "basico", nivel: this.nivel)));
              },
              child: Row(
                children: [
                  
                  (nivel == 1)
                    ? Image(image: AssetImage('assets/images/simulador/facil.png'))
                    : (nivel == 2) 
                      ? Image(image: AssetImage('assets/images/simulador/medio.png'))
                      : Image(image: AssetImage('assets/images/simulador/dificil.png')),
                  
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${materia.name}",
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 10),
                        Text("Resuelve problemas utilizando tu razonamiento",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: 12),
                        Text("${materia.numPreguntas.toString()} Preguntas",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
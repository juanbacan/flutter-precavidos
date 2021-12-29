import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';

import 'cuestionario_page.dart';

final Map<String, List<Materia>> categoriasInfo = {
  "logico": [
    Materia("Ecuaciones algebraicas", 20, "logico.png", "Ecuaciones algebraicas"),
    Materia("Conteo y combinatoria", 20, "logico.png", "Conteo y combinatoria"),
    Materia("Sucesiones", 20, "logico.png", "Sucesiones"),
  ],
  "abstracto": [
    Materia("Imaginación espacial", 20, "abstracto.png", "Imaginación espacial"),
    Materia("Transformación entre gráficos 2D y 3D", 20, "abstracto.png", "Transformación entre gráficos 2D y 3D"),
    Materia("Series gráficas", 20, "abstracto.png", "Series gráficas"),
    Materia("Secuencias gráficas horizontales", 20, "abstracto.png", "Secuencias gráficas horizontales"),
    Materia("Perspectivas de objetos", 20, "abstracto.png", "Perspectivas de objetos"),
    Materia("Secuencias gráficas horizontales", 20, "abstracto.png", "Secuencias gráficas horizontales"),
    Materia("Matrices gráficas", 20, "abstracto.png", "Matrices gráficas"),
    Materia("Analogías entre figuras", 20, "abstracto.png", "Analogías entre figuras"),
    Materia("Figuras excluidas", 20, "abstracto.png", "Figuras excluidas"),
    Materia("Conjuntos gráficos", 20, "abstracto.png", "Conjuntos gráficos"),
  ],
  "verbal": [
    Materia("Significado de palabras", 20, "verbal.png", "Significado de palabras"),
    Materia("Relaciones sintácticas", 20, "verbal.png", "Relaciones sintácticas"),
    Materia("Analogías verbales", 20, "verbal.png", "Analogías verbales"),
    Materia("Lectura critica", 20, "verbal.png", "Lectura critica"),
    Materia("Sinónimos y antónimos", 20, "verbal.png", "Sinónimos y antónimos"),
    Materia("Comprensión lectora", 20, "verbal.png", "Comprensión lectora:"),
  ],
  "numerico": [
    Materia("Probabilidad, combinación y variación", 20, "numerico.png", "Probalidad, combinación y variación"),
    Materia("Ecuaciones", 20, "numerico.png", "Ecuaciones"),
    Materia("Razones y proporciones", 20, "numerico.png", "Razones y proporciones"),
  ]
};

class CursoAvanzadoPage extends StatelessWidget {
  const CursoAvanzadoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    AppBarPrecavidos(titulo: 'Curso Avanzado', color: MyColors.cursoAvanzado),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("Resuelve cuestionarios por categorías, con preguntas aleatorias en cada intento."),
                          SizedBox(height: 10),
                          _Title(text: "Razonamiento Lógico"),
                          _MateriasCard(materias: categoriasInfo["logico"]!),
                          _Title(text: "Razonamiento Numérico"),
                          _MateriasCard(materias: categoriasInfo["numerico"]!),
                          _Title(text: "Razonamiento Verbal"),
                          _MateriasCard(materias: categoriasInfo["verbal"]!),
                          _Title(text: "Razonamiento Abstracto"),
                          _MateriasCard(materias: categoriasInfo["abstracto"]!),
                          SizedBox(height: 20,)
                        ]
                      ),
                    ),
                  ],
                )
              ),
            ),
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
    required this.materias,
  });

  final List<Materia> materias;

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
              color: MyColors.cursoAvanzadoLight,
            ),
            width: 300,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CuestionarioPage(materia: materia, curso: "avanzado",)));
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/${materia.image}')),
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
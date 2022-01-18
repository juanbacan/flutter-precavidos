import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/pages/calcular_nota_page.dart';
import 'package:precavidos_simulador/src/pages/contra_reloj_materias_page.dart';
import 'package:precavidos_simulador/src/pages/curso_avanzado_page.dart';
import 'package:precavidos_simulador/src/pages/curso_basico_page.dart';
import 'package:precavidos_simulador/src/pages/practicar_page.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {

    final List<Materia> materias = [
      Materia("Razonamiento Lógico", 20, "logico.png", "logico"),
      Materia("Razonamiento Numérico", 20, "numerico.png", "numerico"),
      Materia("Razonamiento Verbal", 20, "verbal.png", "verbal"),
      Materia("Razonamiento Abstracto", 20, "abstracto.png", "abstracto"),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              _TitleHome(text: "Simulador Examen Transformar Precavidos"),

              BannerAdGoogle(),

              _TitleHome(text: "Categorias"),
        
              _MateriasCard(materias: materias),      // Tarjetas de las Materias
              
              _TitleHome(text: "Simuladores"),
      
              Row(
                children: [
                  _CursosCard(image: "curso_basico.jpeg", url: "basico"),
                  _CursosCard(image: "curso_avanzado.jpeg", url: "avanzado"),
                ],
              ),
      
              _TitleHome(text: "Contra Reloj"),
      
              _Tarjeta(
                ruta: (context) => ContraRelojMateriasPage(),
                color: MyColors.contraRelojLight,
                image: "assets/images/contra_reloj.png",
                text: "Responde las preguntas correctamente lo más rápido que puedas",
              ),
        
              _TitleHome(text: "Calcular Nota"),

              _Tarjeta(
                ruta: (context) => CalcularNotaPage(),
                color: MyColors.calcularNotaLight,
                image: "assets/images/calcular_nota.png",
                text: "Calcula tu nota de postulación",
              ),

              SizedBox(height: 50),

              BannerAdGoogle()
          
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Tarjeta extends StatelessWidget {

  final Widget Function(BuildContext) ruta;
  final Color color;
  final String image;
  final String text;
  
  const _Tarjeta({
    required this.ruta,
    required this.color,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 130,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            
            Navigator.push(
              context, MaterialPageRoute(builder: this.ruta)
            );
          },            

          child: Row(
            children: [
              Image(image: AssetImage(image)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleHome extends StatelessWidget {

  final String text;

  const _TitleHome({
    required this.text,
  });

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

class _CursosCard extends StatelessWidget {

  final String image;
  final String url;

  const _CursosCard({
    Key? key,
    required this.image,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              //spreadRadius: 0.2,
              blurRadius: 4,
              offset: Offset(2, 2)
            )
          ]
        ),
        child: InkWell(
          onTap: () {

            if(url == "basico"){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => CursoBasicoPage())
              );
            }else if(url == "avanzado"){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => CursoAvanzadoPage())
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage("assets/images/$image"),
            ),
          ),
        ),
      ),
    );
  }
}

class _MateriasCard extends StatelessWidget {
  const _MateriasCard({
    Key? key,
    required this.materias,
  }) : super(key: key);

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
              color: Theme.of(context).secondaryHeaderColor,
            ),
            width: 280,
            child: InkWell(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => CuestionarioPage(materia: materia.url)));
                Navigator.push(context, MaterialPageRoute(builder: (context) => PracticarPage(materia: materia.url)));
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/${materia.image}')),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${materia.name}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text("Resuelve problemas utilizando tus conocimientos",
                          style: Theme.of(context).textTheme.caption,
                        ),
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
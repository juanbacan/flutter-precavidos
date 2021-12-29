import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/models/materias_model.dart';
import 'package:precavidos_simulador/src/pages/contra_reloj_page.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';

final List<Materia> tarjetas = [
  Materia("Razonamiento Lógico", 10, "logico.png", "logico"),
  Materia("Razonamiento Numérico", 10, "numerico.png", "numerico"),
  Materia("Razonamiento Verbal", 10, "verbal.png", "verbal"),
  Materia("Razonamiento Abstracto", 10, "abstracto.png", "abstracto"),
];

class ContraRelojMateriasPage extends StatelessWidget {
  const ContraRelojMateriasPage({Key? key}) : super(key: key);

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
                    AppBarPrecavidos(titulo: 'Contra Reloj', color: MyColors.contraReloj),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: tarjetas.length,
                      itemBuilder: (BuildContext context, int index){
                      
                        final tarjeta = tarjetas[index];
                      
                        return(
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.04),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.contraRelojLight,
                            ),
                            height: 130,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContraRelojPage(materia: tarjeta)));
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage('assets/images/${tarjeta.image}')
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(tarjeta.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                          Text("${tarjeta.numPreguntas.toString()} preguntas")
                                        ],
                                      )
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded, color: MyColors.contraReloj)
                                  ],
                                )  
                              ),
                            ),
                          )
                        );
                      }
                    ),
                    SizedBox(height: 20,)
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

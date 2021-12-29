import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';


showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
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
              Navigator.pop(context);           // TODO Revisar si esta bien esta parte
            }, child: Text("Si")),
            SizedBox(width: 20),
            ElevatedButton(onPressed: (){
              Navigator.pop(context, false);
            }, child: Text("No"))
          ],
        ) 
      ]
    )
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class AppBarPreguntas extends StatelessWidget {

  final String titulo;
  final int preguntaActual;
  final int numPreguntas;
  final bool? alertDialog;

  const AppBarPreguntas({ 
    required this.titulo,
    required this.preguntaActual,
    required this.numPreguntas,
    this.alertDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              if (alertDialog == null){
                Navigator.pop(context);
              }
              else if(alertDialog == true){
                showAlertDialog(context);
              }
              else{
                Navigator.pop(context);
              }
            }, 
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                child: Text(titulo, 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ), 
              SizedBox(height: 1),

              Text(
                "Pregunta ${preguntaActual + 1}/$numPreguntas", 
                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
              ),

            ],
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor)     //TODO
          ),     
        ],
      ),
    );
  }
}


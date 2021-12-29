import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';

class Logo extends StatelessWidget {

  final String titulo;

  const Logo({ required this.titulo });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only( top: 30 ),
        width: 150,
        child: SafeArea(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/logo.png')),
              Text(this.titulo, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: MyColors.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
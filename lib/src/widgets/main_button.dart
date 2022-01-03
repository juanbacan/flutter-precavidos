import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';

class MainButton extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;

  const MainButton({
    required this.text, 
    this.onPressed
  }); 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        primary: MyColors.primaryColor,
        shape: StadiumBorder(),
      ),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 46,
        child: Center(
          child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }
}
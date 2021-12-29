import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final Color? color;

  const CustomInput({
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false,
    this.color,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        //cursorColor: Colors.white,
        //style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        obscureText: this.isPassword,
        controller: this.textController,
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          hintText: this.placeholder,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            this.icon,
            color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }
}
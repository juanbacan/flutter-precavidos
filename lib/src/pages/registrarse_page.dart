import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:precavidos_simulador/src/widgets/custom_input.dart';
import 'package:precavidos_simulador/src/widgets/labels.dart';
import 'package:precavidos_simulador/src/widgets/logo.dart';
import 'package:precavidos_simulador/src/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrarsePage extends StatelessWidget {
  const RegistrarsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      //backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: "Registrarse"),
                
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await authService.googleLogin();  
                        Navigator.pop(context);
                        
                      } catch (e) {
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/images/google_icon.png'), width: 45,),
                          SizedBox(width: 10),
                          Text("Ingresar con Google", style: TextStyle(fontSize: 17))
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await authService.facebookLogin();
                        Navigator.pop(context);
                      } catch (e) {
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Color.fromRGBO(60, 88, 158, 1),
                        //color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/images/facebook_icon.png'), width: 44,),
                          SizedBox(width: 10),
                          Text("Ingresar con Facebook", style: TextStyle(fontSize: 17, color: Colors.white))
                          //Text("Ingresar con Facebook", style: TextStyle(fontSize: 17))
                        ],
                      ),
                    ),
                  ),
                ),
          
                SizedBox(height: 30),

                Text("o puedes registrarte con:"),

                SizedBox(height: 30),
          
                _Form(),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Labels(mensaje1: "¿Ya tienes cuenta?", mensaje2: "Ingresa ahora")
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () async{
                    if (!await launch("https://precavidos.com/terminos-condiciones")) throw 'Could not launch';
                  },
                  child: Text("Terminos y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200))
                ),
                SizedBox( height: 1 ),
              ]
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  bool error = false;
  String msg = "";
  
  final emailCtlr = TextEditingController();
  final passCtlr = TextEditingController();
  final passCtlrAgain = TextEditingController();

  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            keyboardType: TextInputType.emailAddress,
            textController: emailCtlr,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",    
            textController:passCtlr,
            isPassword: true,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Repita la Contraseña",    
            textController:passCtlrAgain,
            isPassword: true,
          ),
          
          SizedBox(height: 30),
          
          (error) ?
            Column(
              children: [
                Text(msg, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10)
              ],
            ):
            SizedBox.shrink(),


          MainButton(
            text: "Registrarse",
            onPressed: () async{ 
              try {
                if(passCtlr.text.trim() == passCtlrAgain.text.trim()){
                  if(passCtlr.text.trim().length <= 7 ){
                    setState(() {
                      error = true;
                      msg = "Ha ocurrido un error, la longitud de la contraseña debe ser mayor a 8 caracteres";
                    });
                  }else{
                    String resp = await authService.createUserWithEmailAndPassword(emailCtlr.text.trim(), passCtlr.text.trim());
                    if(resp == "Ok") {
                      Navigator.pop(context);
                      return;
                    }
                    setState(() {
                      error = true;
                      msg = resp;
                    });
                  }

                }else{
                  setState(() {
                    error = true;
                    msg = "Ha ocurrido un error, revise que las contraseñas sean iguales e inténtelo más tarde";
                  });
                }
              } catch (e) {
                setState(() {
                  error = true;
                });
              }
            },
          ),
         ]
       )
    );
  }
}
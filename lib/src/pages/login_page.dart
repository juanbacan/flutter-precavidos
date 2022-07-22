import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/pages/registrarse_page.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:precavidos_simulador/src/widgets/custom_input.dart';
import 'package:precavidos_simulador/src/widgets/labels.dart';
import 'package:precavidos_simulador/src/widgets/logo.dart';
import 'package:precavidos_simulador/src/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                Logo(titulo: "Precavidos"),
                
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: InkWell(
                    onTap: () async {
                      try {
                        await authService.googleLogin();  
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
                          Image(image: AssetImage('assets/images/google_icon.png'), width: 40,),
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

                Text("o puedes ingresar con"),

                SizedBox(height: 30),
          
                _Form(),
                SizedBox(height: 30),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => RegistrarsePage()
                      )
                    );
                  },
                  child: Labels(mensaje1: "¿No tienes cuenta?", mensaje2: "Crea una ahora")),
                SizedBox(height: 30),
                InkWell(
                  onTap: () async{
                    if (!await launch("https://precavidos.com/terminos-condiciones")) throw 'No se ha podido lanzar';
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
            text: "Ingresar",
            onPressed: () async{ 
              //authService.signInWithEmailAndPassword(emailCtlr.text.trim(), passCtlr.text.trim());

              try {

                String resp = await authService.signInWithEmailAndPassword(emailCtlr.text.trim(), passCtlr.text.trim());
                print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                print(resp);
                if(resp == "Ok") return;
                setState(() {
                  error = true;
                  msg = resp;
                });

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
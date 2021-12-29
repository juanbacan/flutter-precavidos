import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/comentario_response.dart';
import 'package:precavidos_simulador/src/models/comentario_un_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:precavidos_simulador/src/models/usuario.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:precavidos_simulador/src/services/preguntas_service.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/utils/my_snackbar.dart';


class ResponderPage extends StatelessWidget {

  final String preguntaId;
  final PreguntasService preguntasService;

  // Si se va a actualizar la solución
  final bool? actualizar;
  final String? comentario;
  final String? idComentario;

  const ResponderPage({
    required this.preguntaId,
    required this.preguntasService,

    this.actualizar,
    this.comentario,
    this.idComentario
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => new PreguntasService(),
      child: Scaffold(
        body: SafeArea(
          child: ResponderInfo(
            preguntaId: this.preguntaId, 
            preguntasService: this.preguntasService,
            actualizar: this.actualizar,
            comentario: this.comentario,
            idComentario: this.idComentario
          )
        ),
      ),
    );
  }
}

class ResponderInfo extends StatefulWidget {

  final String preguntaId;
  final PreguntasService preguntasService;

  final bool? actualizar;
  final String? comentario;
  final String? idComentario;

  ResponderInfo({
    required this.preguntaId,
    required this.preguntasService,

    this.actualizar,
    this.comentario,
    this.idComentario
  });

  @override
  _ResponderInfoState createState() => _ResponderInfoState();
}

class _ResponderInfoState extends State<ResponderInfo> {

  HtmlEditorController controller = HtmlEditorController();
  bool agregandoComentario = false;

  @override
  Widget build(BuildContext context) {

    final _authService = Provider.of<AuthService>(context);
    final Usuario? usuario = _authService.usuario;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          HtmlEditor(
            controller: controller, //required
            htmlEditorOptions: HtmlEditorOptions(
              hint: "Escribe tu solución aquí...",
              initialText: (widget.actualizar != null) 
              ? widget.comentario
              : "<p><b>Solución:</b></p><p><br></p><p><b>Explicación:</b></p><p><br></p>",
              shouldEnsureVisible: true,
              autoAdjustHeight: true,
              adjustHeightForKeyboard: true
            ),  
            htmlToolbarOptions :  HtmlToolbarOptions (
              defaultToolbarButtons : [
                FontButtons(strikethrough: false, clearAll: false),                
                ParagraphButtons (lineHeight :  false , caseConverter :  false, textDirection: false ),
                InsertButtons(audio: false, video: false, picture: false)
              ],
              initiallyExpanded: false,
              //toolbarPosition: ToolbarPosition.belowEditor,
              toolbarType: ToolbarType.nativeGrid
            ),
            otherOptions: OtherOptions(
              height: MediaQuery.of(context).size.height -200
            ),
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    // Evita agregar doble comentario
                    if(agregandoComentario) return;
                    
                    setState(() {
                      agregandoComentario = true;
                    });

                    final String texto = await controller.getText();
                    final int longitud = texto.length;
                    print(texto.length);
                    print(widget.preguntaId);
                    if(usuario == null){
                      return;
                    }
                    else if(longitud < 90){
                      MySnackbar.show(context, "La solución debe contener al menos 20 caracteres de longitud");
                      return;
                    }
                    else if(longitud > 2000){
                      MySnackbar.show(context, "La solución debe contener al menos 20 caracteres de longitud");
                      return;
                    }

                    // **************************** Agregando *********************************
                    if(widget.actualizar == null){
                      try {
                        final String idToken = await _authService.getTokenUser();
                        final resp = await http.put(Uri.parse("${ Environment.apiURL }/pregunta/comentario/${widget.preguntaId}"),
                          body: json.encode(
                            {
                              "comentario": texto,
                              "uid": usuario.id,
                              "photoURL": usuario.photoUrl,
                              "date": DateTime.now().millisecondsSinceEpoch,
                              "likes": [],
                              "displayName": usuario.displayName
                            }
                          ),
                          headers: {
                            'Content-Type': 'application/json',
                            'x-token': idToken
                          }
                        ); 

                        final comentarioResponse = comentarioResponseFromJson( resp.body );
                        widget.preguntasService.comentarios = comentarioResponse.comentarios;

                      } catch (e) {
                        print(e);
                      }
                    }
                    // ************************** Actualizando *****************************
                    else{

                      if(texto == widget.comentario){
                        setState(() {
                          agregandoComentario = false;
                        });
                        Navigator.pop(context);
                        return;
                      }

                      try {
                        print("Actualizando");

                        final String idToken = await _authService.getTokenUser();
                        final resp = await http.put(Uri.parse("${ Environment.apiURL }/pregunta/comentario/actualizar/${widget.idComentario}"),
                          body: json.encode(
                            {
                              "comentario": texto,
                            }
                          ),
                          headers: {
                            'Content-Type': 'application/json',
                            'x-token': idToken
                          }
                        ); 
                        
                        final comentarioUnResponse = comentarioUnResponseFromJson( resp.body );
                        widget.preguntasService.actualizarComentarios(comentarioUnResponse.comentario);

                      } catch (e) {
                        print(e);
                      }
                    }

                    setState(() {
                      agregandoComentario = false;
                    });

                    Navigator.pop(context);

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.actualizar != null ? "ACTUALIZAR" :"AGREGAR", 
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, )
                        ),
                        SizedBox(width: 7),
                        Icon(Icons.send, color: Colors.white, size: 19,)
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
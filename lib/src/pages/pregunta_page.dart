import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/comentario_model.dart';
import 'package:precavidos_simulador/src/models/usuario.dart';
import 'package:precavidos_simulador/src/pages/responder_page.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/services/preguntas_service.dart';
import 'package:provider/provider.dart';

final Map<String, String> materias = {
  "logico": "Razonamiento Lógico",
  "numerico": "Razonamiento Numérico",
  "verbal": "Razonamiento Verbal",
  "abstracto": "Razonamiento Abstracto"
};

class PreguntaPage extends StatelessWidget {

  final String preguntaId;

  const PreguntaPage({
    required this.preguntaId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => new PreguntasService(),
      child: Scaffold(
        body: SafeArea(
          child: PreguntaInfo(preguntaId: this.preguntaId),
        ),
      ),
    );
  }
}

class PreguntaInfo extends StatefulWidget {

  final String preguntaId;

  PreguntaInfo({
    required this.preguntaId,
  });

  @override
  _PreguntaInfoState createState() => _PreguntaInfoState();
}

class _PreguntaInfoState extends State<PreguntaInfo> {

  Pregunta? pregunta;
  List<String>? likes;
  bool agregandoLike = false;

  @override
  void initState() {

    this._consultarPregunta();

    super.initState();
  }

  void _consultarPregunta() async {
    final _preguntasService = Provider.of<PreguntasService>(context, listen: false);
    this.pregunta = await _preguntasService.getPreguntaById(widget.preguntaId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final _authService = Provider.of<AuthService>(context);
    final Usuario? usuario = _authService.usuario;
    
    final _preguntasService = Provider.of<PreguntasService>(context, listen: true);

    return (this.pregunta == null) 
      ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          
          _HeaderPregunta(pregunta: pregunta),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Html(data: pregunta!.enunciado),
                    ),

                    _RespuestaCorrecta(pregunta: pregunta),

                    Divider(thickness: 10 ),
                    
                    _preguntasService.comentarios?.length == 0 ?
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Text("Aún nadie a agregado una respuesta.", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text("¡Sé el primero en responder!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        )
                      ) :             
                      
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _preguntasService.comentarios?.length,
                        itemBuilder: (BuildContext context, int index){
                          
                          //print(_preguntasService.comentarios);
                          //final Comentario comentario = pregunta!.comentarios![index]!;
                          final Comentario comentario = _preguntasService.comentarios![index]!;
                          final int numLikes = comentario.likes.length;
                          likes = comentario.likes;

                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 21),
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Respuesta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Row(
                                      children: [
                                        (numLikes == 0) ?
                                          Icon(Icons.favorite_border, size: 19):
                                          Icon(Icons.favorite, size: 19, color: Color.fromRGBO(255, 121, 104, 1)),        
                                        SizedBox(width: 3),
                                        Text("$numLikes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        
                                        (usuario != null && usuario.id == comentario.uid)
                                          ? PopupMenuButton(
                                            onSelected: (result){
                                              
                                              Navigator.push(
                                                context, 
                                                MaterialPageRoute(
                                                  builder: (context) => ResponderPage(
                                                    preguntaId: this.pregunta!.id, 
                                                    preguntasService: _preguntasService,
                                                    actualizar: true,
                                                    comentario: comentario.comentario,
                                                    idComentario: comentario.id
                                                  )
                                                )
                                              );
                                            },
                                            itemBuilder: (BuildContext context) => [
                                              const PopupMenuItem(child: Text("Editar Solución"), value: "Editar",)
                                            ],
                                          )
                                          : SizedBox.shrink()
                                      ],
                                    ),
                                  ],
                                )
                              ),
                              
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Html(data: comentario.comentario)
                              ),

                              SizedBox(height: 10),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        (comentario.photoUrl != null)
                                          ? CircleAvatar(
                                            radius: 18,
                                            backgroundImage: NetworkImage(comentario.photoUrl!),
                                          )
                                          : CircleAvatar(
                                            radius: 18,
                                            child: Text("${comentario.displayName[0]}", style: TextStyle(fontSize: 25),),
                                          ),
                                        SizedBox(width: 10),
                                        Text(comentario.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Divider(thickness: 2 ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 10),

                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(right: 22),
                                  child: InkWell(
                                    onTap: () async {
                                      if(usuario == null || likes!.contains(usuario.id)) return;
                                      print("Agregando un nuevo like al comentario");

                                      if(agregandoLike) return;

                                      // TODO Mosrar modal si no hay usuario

                                      // Agrega un nuevo like al comentario
                                      setState(() {
                                        agregandoLike = true;
                                        likes = comentario.likes;
                                        likes!.add(usuario.id);
                                      });
                                      
                                      try {
                                        final String idToken = await _authService.getTokenUser();
                                        final resp = await http.put(Uri.parse("${ Environment.apiURL }/pregunta/likes/${comentario.id}"),
                                          body: json.encode(
                                            {
                                              "idComentario": comentario.id,
                                              "likes": likes
                                            }
                                          ),
                                          headers: {
                                            'Content-Type': 'application/json',
                                            'x-token': idToken
                                          }
                                        ); 
                                        setState(() {
                                          agregandoLike = false;
                                        });   
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: (usuario == null || !likes!.contains(usuario.id)) 
                                          ? Color.fromRGBO(236, 236  , 236, 1) 
                                          : Color.fromRGBO(255, 228  , 225, 1),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (usuario == null || !likes!.contains(usuario.id)) 
                                            ? Icon(Icons.favorite_border, size: 19)
                                            : Icon(Icons.favorite, size: 19, color: Color.fromRGBO(255, 121, 104, 1)),
                                          SizedBox(width: 5),
                                          Text("GRACIAS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                          SizedBox(width: 5),
                                          Text("$numLikes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 10 ),  
                            ],
                          );
                        }
                      )
                  ],
                ),
              ),
            )
          ),

          _AgregarSolucion(preguntaId: widget.preguntaId),
        ],
      )
    ;
  }
}

class _AgregarSolucion extends StatelessWidget {
  
  const _AgregarSolucion({
    required this.preguntaId,
  });

  final String preguntaId;

  @override
  Widget build(BuildContext context) {

    final _preguntasService = Provider.of<PreguntasService>(context);

    return Container(
      color: MyColors.primaryOpacityColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){

              // TODO Mostrar Modal si no hay usuario

              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ResponderPage(preguntaId: this.preguntaId, preguntasService: _preguntasService)
                 )
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width*0.8,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text("AGREGAR SOLUCIÓN", 
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, )
              )
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderPregunta extends StatelessWidget {
  const _HeaderPregunta({
    Key? key,
    required this.pregunta,
  }) : super(key: key);

  final Pregunta? pregunta;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back_ios_new_outlined, size: 18.0,)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(materias[pregunta?.tipo] ?? "Sin Categroría", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          IconButton(
            color: Color.fromRGBO(85, 85, 85, 1),
            onPressed: (){
              Share.share('Héchale un vistazo a esta pregunta \n https://precavidos.com/pregunta/${pregunta?.id}');
            }, 
            icon: Icon(Icons.share)
          )
        ],
      ),
    );
  }
}

class _RespuestaCorrecta extends StatelessWidget {
  const _RespuestaCorrecta({
    Key? key,
    required this.pregunta,
  }) : super(key: key);

  final Pregunta? pregunta;

  @override
  Widget build(BuildContext context) {

    final Map<ImageSourceMatcher, ImageRender> defaultImageRenders = {
      assetUriMatcher(): assetImageRender(),
      networkSourceMatcher(extension: "svg"): svgNetworkImageRender(),
      networkSourceMatcher(): networkImageRender(width: 150),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[300], size: 19),
              SizedBox(width: 5),
              Text("Respuesta Correcta", style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          Html(
            data: pregunta?.respuestas.toJson()[pregunta?.respuestaCorrecta],
            customImageRenders: defaultImageRenders,
          ),
        ],
      ),
    );
  }
}
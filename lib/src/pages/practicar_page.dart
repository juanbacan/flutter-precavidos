import 'dart:math';

import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/pages/pregunta_page.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:precavidos_simulador/src/models/pregunta.dart';
import 'package:precavidos_simulador/src/services/practicar_service.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPreguntas.dart';
import 'package:precavidos_simulador/ad_helper.dart';


final Map<String, String> materias = {
  "logico": "Razonamiento Lógico",
  "numerico": "Razonamiento Numérico",
  "verbal": "Razonamiento Verbal",
  "abstracto": "Razonamiento Abstracto"
};

class PracticarPage extends StatelessWidget {
  const PracticarPage({Key? key, required this.materia}) : super(key: key);

  final String materia;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => new PracticarService(),
      child: Scaffold(
        body: SafeArea(
          child: _Practicar(materia: this.materia),
        ),
      ),
    );
  }
}

class _Practicar extends StatefulWidget {

  final String materia;

  _Practicar({Key? key, required this.materia}) : super(key: key);

  @override
  __PracticarState createState() => __PracticarState();
}

class __PracticarState extends State<_Practicar> {

  List<Pregunta>? preguntas;
  int preguntaActual = 0;
  bool correcta = false;


  // Publicidad *******************************
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 2;
  int maxFailedLoadAttempts = 3;
  // ******************************************

  Map<String, bool> userCheck = {
    "respuesta1": false,
    "respuesta2": false, 
    "respuesta3": false,
    "respuesta4": false,
  };

  @override
  void initState() {
    this._cargarPreguntas();

    _createInterstitialAd();    // Publicidad
    super.initState();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
        
      )
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('ad onAdShowedFullScreenContent.'),

      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _cargarPreguntas() async {
    final practicarService = Provider.of<PracticarService>(context, listen: false);
    this.preguntas = await practicarService.getPreguntas(widget.materia);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    Pregunta? pregunta = this.preguntas?[preguntaActual];
    final numPreguntas = this.preguntas?.length;

    return (this.preguntas == null)
    ? Center(child: CircularProgressIndicator())
    : Column(
      children: [
        AppBarPreguntas(titulo: materias[widget.materia]!, preguntaActual: preguntaActual, numPreguntas: numPreguntas!),

        SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only( bottom: 50 ),
              child: Column(
                children: [
                  Html(data: pregunta!.enunciado),
                  SizedBox(height: 20),
                  _opciones(pregunta),
                ],
              ),
            ),
          )
        ),
        _bottomOptions(numPreguntas, pregunta.respuestaCorrecta, pregunta.id)
      ],
    );
  }

  Widget _opciones(Pregunta pregunta){

    String respuestaCorrecta = pregunta.respuestaCorrecta;
    List<Widget> list = [];

    checkResponse(String respuesta) {

      if(correcta == true){
        return;
      }
      else{
        userCheck = {
          "respuesta1": false,
          "respuesta2": false, 
          "respuesta3": false,
          "respuesta4": false,
        };
      }

      if(respuestaCorrecta == respuesta){
        setState(() {
          userCheck[respuesta] = true;
          correcta = true;
        });
      }else{
        setState(() {
          userCheck[respuesta] = true;
        });
      }
    } 

    for (String respuesta in pregunta.respuestas.toJson().keys) {

      list.add(
        new GestureDetector(
          onTap: () => checkResponse(respuesta),
          child: Container(
            margin: EdgeInsets.symmetric( vertical: 5 ),
            padding: EdgeInsets.symmetric( vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ( !userCheck[respuesta]! ) ? MyColors.primaryColorDark : (correcta) ? MyColors.correct : MyColors.incorrect, 
                width: 2.5
              )
            ),
            child: Row(
              children: [
                SizedBox( width: 8 ),
                ( !userCheck[respuesta]! )
                  ? Icon(Icons.circle_outlined, color: MyColors.primaryColorDark)
                  : (correcta)
                  ? Icon(Icons.check_circle_outline_outlined, color: MyColors.correct)
                  : Icon(Icons.highlight_off, color: MyColors.incorrect),
                Expanded(
                  child: Html(
                    data: pregunta.respuestas.toJson()[respuesta],
                    customImageRenders: {
                      assetUriMatcher(): assetImageRender(),
                      networkSourceMatcher(extension: "svg"): svgNetworkImageRender(),
                      networkSourceMatcher(): networkImageRender(width: 100),
                    },
                    onImageTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                      checkResponse(respuesta);
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return new Column(
      children: list,
    );
  }

  Widget _bottomOptions(int numPreguntas, String respuestaCorrecta, String idPregunta) {
    return Container( 
        height: 70,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                if(preguntaActual <= 0){
                  return;
                }else{    
                  setState(() {
                    correcta = false;
                    userCheck = {
                      "respuesta1": false,
                      "respuesta2": false, 
                      "respuesta3": false,
                      "respuesta4": false,
                    };
                    preguntaActual--;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigate_before_outlined, color: Colors.white),
                  Text("Anterior", style: TextStyle(color: Colors.white))
                ],
              ),
            ),

            //**********************************************************************************
            InkWell(
              onTap: (){

                // Publicidad *********************************
                Random randomNumber = Random();
                int r = 1 + randomNumber.nextInt(6);

                print(r);

                if(r == 2){
                  _showInterstitialAd();
                }
                // ********************************************

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => PreguntaPage(preguntaId: idPregunta)
                  )
                );
                /*
                if(correcta) return;
                userCheck = {
                  "respuesta1": false,
                  "respuesta2": false, 
                  "respuesta3": false,
                  "respuesta4": false,
                };
                setState(() {
                  userCheck[respuestaCorrecta] = true;
                  correcta = true;
                });
                */
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outlined, color: Colors.white, size: 23,),
                  Text("¿Cómo resolver?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // *******************************************************************************************
            InkWell(
              onTap: (){
                // Publicidad *********************************
                Random randomNumber = Random();
                int r = 1 + randomNumber.nextInt(4);

                print(r);

                if(r == 2){
                  _showInterstitialAd();
                }
                // ********************************************


                if(preguntaActual >= numPreguntas - 1){
                  return;
                }else{    
                  setState(() {
                    correcta = false;
                    userCheck = {
                      "respuesta1": false,
                      "respuesta2": false, 
                      "respuesta3": false,
                      "respuesta4": false,
                    };
                    preguntaActual++;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Siguiente", style: TextStyle(color: Colors.white)),
                  Icon(Icons.navigate_next, color: Colors.white)
                ],
              ),
            ) 
          ],
        ),
      );
  }
}

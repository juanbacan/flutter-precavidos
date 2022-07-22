import 'dart:math';
import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/utils/my_snackbar.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';
import 'package:precavidos_simulador/src/widgets/custom_input.dart';
import 'package:precavidos_simulador/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CalcularNotaPage extends StatefulWidget {
  CalcularNotaPage({Key? key}) : super(key: key);

  @override
  _CalcularNotaPageState createState() => _CalcularNotaPageState();
}

class _CalcularNotaPageState extends State<CalcularNotaPage> {

  final notaGrado = TextEditingController();
  final notaExamen = TextEditingController();
  bool calculada = false;
  double notaPostulacion = 0.0;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 2;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    
    _createInterstitialAd();
    
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

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }


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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBarPrecavidos(titulo: "Calcular Nota", color: MyColors.calcularNota),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ingresa tu nota de grado:"),
                          SizedBox(height: 20),
                          CustomInput(
                            icon: Icons.grading_outlined, 
                            placeholder: "Nota de grado", 
                            textController: notaGrado,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text("Ingresa tu nota del examen:"),
                          SizedBox(height: 20),
                          CustomInput(
                            icon: Icons.grading_outlined, 
                            placeholder: "Nota del examen", 
                            textController: notaExamen,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
            
                        String notaGradoText = notaGrado.text;
                        String notaExamenText = notaExamen.text;
            
                        if(notaGradoText == "" || notaExamenText == ""){
                            MySnackbar.show(context, "Llene todos los campos");
                            return;
                        }
                        
                        double notaGradoFormat = double.parse(notaGradoText.replaceAll(",", "."));
                        String notaGradoFinal = notaGradoFormat.toStringAsFixed(2);
                        
                        double notaExamenFormat = double.parse(notaExamenText.replaceAll(",", "."));
                        String notaExamenFinal = notaExamenFormat.toStringAsFixed(0);
            
                        if(double.parse(notaGradoText) > 10.0 || double.parse(notaGradoText) < 5.0){
                          MySnackbar.show(context, "Nota de grado no válida. La nota de grado debe estar entre 5 y 10");
                          return;
                        }else if(int.parse(notaExamenText) > 1000 || int.parse(notaExamenText) < 400){
                          MySnackbar.show(context, "Nota de examen no válida. La nota del examen debe estar entre 400 y 1000");
                          return;
                        }
            
                        // Genera un número aleatorio de 1 a 3
                        Random randomNumber = Random();
                        int r = 1 + randomNumber.nextInt(3);
            
                        print(r);
            
                        if(r == 2){
                          _showInterstitialAd();
                        }
                        // ***********************************
                        FocusScope.of(context).requestFocus(FocusNode());
                        
                        notaPostulacion = double.parse(notaGradoFinal) * 50 + double.parse(notaExamenFinal) * 0.5;
                        calculada = true;
                        setState(() {});
                        print(notaPostulacion);
                      }, 
                      child: Text("Calcular"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(MyColors.calcularNota),
                      )
                    ),
            
                    SizedBox(height: 30),
            
                    (calculada) 
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: 160,
                            image: AssetImage("assets/images/nota_postulacion.png"),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Tu nota de postulación es:"),
                              SizedBox(height: 10),
                              Text(notaPostulacion.toString(), style: Theme.of(context).textTheme.headline6)
                            ],
                          )
                        ],
                      )
                      : Text("Nota no calculada")
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
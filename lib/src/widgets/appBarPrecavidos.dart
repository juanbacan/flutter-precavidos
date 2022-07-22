import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:precavidos_simulador/ad_helper.dart';

class AppBarPrecavidos extends StatefulWidget {

  final String titulo;
  final Color color;

  const AppBarPrecavidos({
    Key? key,
    required this.titulo,
    required this.color,
  });

  @override
  _AppBarPrecavidosState createState() => _AppBarPrecavidosState();
}

class _AppBarPrecavidosState extends State<AppBarPrecavidos> {

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
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
            color: widget.color
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(widget.titulo, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),)               
          ),
        ),
        Positioned.fill(
          left: 30,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){

                // Genera un número aleatorio de 1 a 3
                Random randomNumber = Random();
                int r = 1 + randomNumber.nextInt(3);

                print(r);

                if(r == 2){
                  _showInterstitialAd();
                }
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30)
            )            
          ),
        ),
      ],
    );
  }
}
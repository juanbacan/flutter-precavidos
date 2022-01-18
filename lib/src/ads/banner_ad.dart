import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ad_helper.dart';

class BannerAdGoogle extends StatefulWidget {

  @override
  _BannerAdState createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAdGoogle> {

  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _ad.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return (_isAdLoaded)
      ? Align(
        alignment: Alignment.center,
        child: Container(
            width: _ad.size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
            child: AdWidget(
              ad: _ad,
            ),
        ),
      )
      : SizedBox.shrink();
  }
}
import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-3940256099942544/6300978111";
      return "ca-app-pub-4779141162178342/5953622579";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4779141162178342/5953622579";
      //return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-3940256099942544/1033173712";
      return "ca-app-pub-4779141162178342/2700966799";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4779141162178342/2700966799";
      //return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  /*static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-8752034118555127/4998693235";
    } else if (Platform.isIOS) {
      //return "ca-app-pub-8752034118555127/4998693235";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }*/
}
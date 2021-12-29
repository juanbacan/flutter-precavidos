import 'dart:io';

class Environment {
  //static String apiURL = Platform.isAndroid ? 'https://servidor3.precavidos.com/api':'https://servidor3.precavidos.com/api';
  static String apiURL = Platform.isAndroid ? 'http://10.0.2.2:3001/api':'http:/10.0.2.2:3001/api';
  static String socketURL = Platform.isAndroid ? 'http://10.0.2.2:3001/api':'http:/10.0.2.2:3001/api';
  //static String socketURL = Platform.isAndroid ? 'https://servidor3.precavidos.com/api':'https://servidor3.precavidos.com/api';
}
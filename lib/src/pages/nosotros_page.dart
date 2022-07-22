import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';
import 'package:precavidos_simulador/src/widgets/appBarPrecavidos.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


class NosotrosPage extends StatefulWidget {
  const NosotrosPage({Key? key}) : super(key: key);

  @override
  State<NosotrosPage> createState() => _NosotrosPageState();
}

class _NosotrosPageState extends State<NosotrosPage> {

  final _dialog = RatingDialog(
    // your app's name?
    title: Text('Califícanos en Google Play', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
    // encourage your user to leave a high rating?
    message: Text('Selecciona el número de estrellas.',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
    // your app's logo?
    image: const Image(image: AssetImage("assets/icon/Logo.png"), width: 100,),
    submitButtonText: 'Enviar',
    starSize: 30.0,
    commentHint: "Déjanos tus comentarios",
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      //print('rating: ${response.rating}, comment: ${response.comment}');
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        //OpenAppstore.launch(androidAppId: "com.preonline");
        LaunchReview.launch(androidAppId: "com.preonline");
      }
    },
  );


  @override
  Widget build(BuildContext context) {

    void _launchSocial(String url, String fallbackUrl) async {
      // Don't use canLaunch because of fbProtocolUrl (fb://)
      try {
        bool launched =
            await launch(url, forceSafariVC: false, forceWebView: false);
        if (!launched) {
          await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
          }
      } catch (e) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  children: [
                    AppBarPrecavidos(titulo: "Acerca de Precavidos", color: MyColors.primaryColor),
                    SizedBox(height: 20),
                    // Image(image: AssetImage("assets/icon/Logo.png"), width: 250,),
                    
                    Text("Síguenos en Nuestras Redes Sociales",             
                      style: Theme.of(context).textTheme.headline6
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      child: Image(image: AssetImage("assets/icon/facebook.png"), width: 200),
                      onTap: ()async{
                        //_launchSocial('fb://profile/408834569303957', 'https://www.facebook.com/PrecavidosEC');
                        if (!await launch("https://www.facebook.com/PrecavidosEC")) throw 'No se ha podido lanzar';
                      },
                    ),
                    InkWell(
                      child: Image(image: AssetImage("assets/icon/tiktok.png"), width: 200),
                      onTap: () async{
                        // _launchSocial('fb://profile/408834569303957', 'https://www.tiktok.com/@precavidos_ec');
                        if (!await launch("https://www.tiktok.com/@precavidos_ec")) throw 'No se ha podido lanzar';
                      },
                    ),
                    InkWell(
                      child: Image(image: AssetImage("assets/icon/instagram.png"), width: 200),
                      onTap: () async{
                        //_launchSocial('fb://profile/408834569303957', 'https://www.instagram.com/precavidos_ec');
                        if (!await launch("https://www.instagram.com/precavidos_ec")) throw 'No se ha podido lanzar';
                      },
                    ),

                    SizedBox(height: 20),
                    Text("Califica esta App",             
                      style: Theme.of(context).textTheme.headline6
                    ),
                    ElevatedButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => _dialog,
                        );
                      }, 
                      child: Text("Calificar")
                    )
                  ],
                ),
              ),
            ),

            BannerAdGoogle()
          ],
        )
      ),
    );
  }
}
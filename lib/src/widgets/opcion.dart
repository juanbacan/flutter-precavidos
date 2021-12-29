import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:precavidos_simulador/src/utils/my_colors.dart';

class Opcion extends StatelessWidget {
  const Opcion({
    Key? key,
    required this.contestada,
    required this.correcta,
    required this.enunciado,
    this.onPressed
  }) : super(key: key);

  final bool contestada;
  final bool correcta;
  final String enunciado;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {

    final Map<ImageSourceMatcher, ImageRender> defaultImageRenders = {
      assetUriMatcher(): assetImageRender(),
      networkSourceMatcher(extension: "svg"): svgNetworkImageRender(),
      networkSourceMatcher(): networkImageRender(width: 100),
    };

    return GestureDetector(
      onTap: this.onPressed ?? (){},
      behavior: HitTestBehavior.opaque,
      
      child: Container(
        margin: EdgeInsets.symmetric( vertical: 5 ),
        padding: EdgeInsets.symmetric( vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (!contestada) ? MyColors.primaryColorDark : (correcta) ? MyColors.correct : MyColors.incorrect, 
            width: 2.5
          )
        ),
        child: Row(
          children: [
            SizedBox( width: 8 ),
            (!contestada)
              ? Icon(Icons.circle_outlined, color: MyColors.primaryColorDark)
              : (correcta)
              ? Icon(Icons.check_circle_outline_outlined, color: MyColors.correct)
              : Icon(Icons.highlight_off, color: MyColors.incorrect),
            Expanded(
              child: Html(
                data: enunciado,
                customImageRenders: defaultImageRenders,
                onImageTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                  onPressed!();
                } 
              ),
            )
          ],
        )
      ),
    );
  }
}

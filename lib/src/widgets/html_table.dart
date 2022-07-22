import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlTable extends StatelessWidget {
  const HtmlTable({
    Key? key,
    required this.data
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        "table": Style(
          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
          alignment: Alignment.center
        ),
        "tr": Style(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
            top: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
          ),
        ),

        "td": Style(
          padding: EdgeInsets.symmetric(horizontal: 17),
          alignment: Alignment.centerLeft,
        ),
      } 
    );
  }
}
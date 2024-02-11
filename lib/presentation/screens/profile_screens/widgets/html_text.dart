import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlContent extends StatelessWidget {
  final dynamic html;
  final Color color;
  final double size;
  const HtmlContent({Key? key, this.html, required this.color, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Html(
      data: html,
        shrinkWrap: true,
      style: {
      "body": Style(
        color: Colors.red,
      fontSize: FontSize(33.0,),
      ),}
      // textStyle: TextStyle(
      //   fontSize: size,
      //   color: color,
      // ),
      // customStylesBuilder: (element) {
      //   return {
      //     'text-overflow': 'ellipsis',
      //     'max-lines': '2',
      //     'font-weight': '600',
      //     'font-size': '16'
      //   };
      // }
        ),
  );
    }
}

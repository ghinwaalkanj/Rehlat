import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree


//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  final Color color;

  RPSCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size,) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.9974684,size.height*0.1000000);
    path_0.lineTo(size.width*0.9974684,size.height*0.9000000);
    path_0.cubicTo(size.width*0.9974684,size.height*0.9517750,size.width*0.9804658,size.height*0.9937500,size.width*0.9594937,size.height*0.9937500);
    path_0.lineTo(size.width*0.3598886,size.height*0.9937500);
    path_0.cubicTo(size.width*0.3470759,size.height*0.9937500,size.width*0.3361797,size.height*0.9706687,size.width*0.3342329,size.height*0.9394000);
    path_0.cubicTo(size.width*0.3315772,size.height*0.8967125,size.width*0.3176861,size.height*0.8758000,size.width*0.3038785,size.height*0.8761875);
    path_0.cubicTo(size.width*0.2900987,size.height*0.8765688,size.width*0.2760253,size.height*0.8981375,size.width*0.2728253,size.height*0.9404000);
    path_0.cubicTo(size.width*0.2704987,size.height*0.9711000,size.width*0.2596101,size.height*0.9937500,size.width*0.2470028,size.height*0.9937500);
    path_0.lineTo(size.width*0.04050633,size.height*0.9937500);
    path_0.cubicTo(size.width*0.01953349,size.height*0.9937500,size.width*0.002531646,size.height*0.9517750,size.width*0.002531646,size.height*0.9000000);
    path_0.lineTo(size.width*0.002531646,size.height*0.1000000);
    path_0.cubicTo(size.width*0.002531646,size.height*0.04822331,size.width*0.01953349,size.height*0.006250000,size.width*0.04050633,size.height*0.006250000);
    path_0.lineTo(size.width*0.2465359,size.height*0.006250000);
    path_0.cubicTo(size.width*0.2593570,size.height*0.006250000,size.width*0.2703797,size.height*0.02945744,size.width*0.2725671,size.height*0.06073919);
    path_0.cubicTo(size.width*0.2755899,size.height*0.1039206,size.width*0.2898608,size.height*0.1259331,size.width*0.3038405,size.height*0.1263013);
    path_0.cubicTo(size.width*0.3178456,size.height*0.1266694,size.width*0.3319468,size.height*0.1052906,size.width*0.3344506,size.height*0.06172800);
    path_0.cubicTo(size.width*0.3362810,size.height*0.02990213,size.width*0.3473165,size.height*0.006250000,size.width*0.3603392,size.height*0.006250000);
    path_0.lineTo(size.width*0.9594937,size.height*0.006250000);
    path_0.cubicTo(size.width*0.9804658,size.height*0.006250000,size.width*0.9974684,size.height*0.04822331,size.width*0.9974684,size.height*0.1000000);
    path_0.close();

    Paint paint0Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.005063291;
    paint0Stroke.color=color;
    canvas.drawPath(path_0,paint0Stroke);

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Colors.white;
    canvas.drawPath(path_0,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
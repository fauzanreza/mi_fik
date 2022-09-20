import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';

//Home bg
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Customable paint path
    var paint = Paint()..strokeWidth = 15;

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = primaryColor;
    canvas.drawPath(mainBackground, paint);

    //Color attribute
    var paint1 = Paint()..color = primaryColor; //Main color
    var paint2 = Paint()..color = Color.fromARGB(255, 192, 115, 0); //Border

    //Right circle
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 50, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 48.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 44, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 42.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 38, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.06), 36.5, paint1);

    //Left circle
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 50, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 48.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 44, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 42.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 38, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.07, size.height * 0.25), 36.5, paint1);

    // paint.color = const Color(0xFF0a0c10);

    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

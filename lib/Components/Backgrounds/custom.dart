import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

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
    var paint2 = Paint()
      ..color = const Color.fromARGB(255, 192, 115, 0); //Border

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//Login Page
class CirclePainterSide extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Customable paint path
    var paint = Paint()..strokeWidth = 15;

    final gradientColors = [
      primaryColor,
      blackbg,
    ];

    final gradientStops = [
      0.0,
      1.0,
    ];

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
      stops: gradientStops,
    );

    final shader =
        gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.shader = shader;

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = primaryColor;
    canvas.drawPath(mainBackground, paint);

    //Color attribute
    var paint1 = Paint()..shader = shader; //Main color
    var paint2 = Paint()
      ..color = const Color.fromARGB(255, 192, 115, 0); //Border

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

    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 50, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 48.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 44, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 42.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 38, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.84), 36.5, paint1);

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

    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 50, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 48.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 44, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 42.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 38, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.13, size.height * 0.88), 36.5, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//Login Page
class CirclePainterSideWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Customable paint path
    var paint = Paint()..strokeWidth = 15;

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = mainbg;
    canvas.drawPath(mainBackground, paint);

    //Color attribute
    var paint1 = Paint()..color = mainbg; //Main color
    var paint2 = Paint()
      ..color = const Color.fromARGB(255, 192, 115, 0); //Border

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
        Offset(size.width * 0.06, size.height * 0.88), 50, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.88), 48.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.88), 44, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.88), 42.5, paint1);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.88), 38, paint2);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.88), 36.5, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

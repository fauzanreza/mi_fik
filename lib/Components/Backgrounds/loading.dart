import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    double fullHeight = Get.height;
    double fullWidth = Get.width;

    return Container(
        height: fullHeight,
        width: fullWidth,
        decoration: BoxDecoration(color: whiteColor),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: Image.asset('assets/icon/mifik_logo.png', height: 75),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(color: primaryColor)
            ]));
  }
}

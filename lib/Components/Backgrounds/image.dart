import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getProfileImageSideBar(double width, String url) {
  if (url != null && url != "null") {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: EdgeInsets.all(paddingXSM),
      decoration: BoxDecoration(
        color: whitebg,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: Image.network(url, width: width * 0.15),
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: EdgeInsets.all(paddingXSM),
      decoration: BoxDecoration(
        color: whitebg,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: Image.asset('assets/icon/default_lecturer.png',
            width: width * 0.15),
      ),
    );
  }
}

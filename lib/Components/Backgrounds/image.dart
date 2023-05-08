import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getProfileImageSideBar(double width, double size, String url) {
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
        child: Image.network(url, width: width * size),
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
            width: width * size),
      ),
    );
  }
}

Widget getProfileImageContent(var url) {
  if (url != null && url != "null") {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: iconLG,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(url)), //For now.
    );
  } else {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        width: iconLG,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset('assets/icon/default_lecturer.png')));
  }
}

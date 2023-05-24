import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
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
      width: iconXL,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(url)), //For now.
    );
  } else {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        width: iconXL,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset('assets/icon/default_lecturer.png')));
  }
}

Widget getMessageImageNoData(String url, String msg, double width) {
  return Column(children: [
    Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20),
      width: width * 0.55,
      height: width * 0.55,
      decoration: BoxDecoration(
        color: whitebg,
        borderRadius: BorderRadius.all(Radius.circular(width * 0.6)),
      ),
      child: ClipRRect(
        child: Image.asset(url, width: width * 0.45),
      ),
    ),
    getSubTitleMedium(msg, greybg)
  ]);
}

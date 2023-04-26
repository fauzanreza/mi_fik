import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ShowProfile extends StatelessWidget {
  final String username;
  final String image;

  ShowProfile({this.username, this.image});

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Container(
      width: fullWidth,
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getProfileImageSideBar(fullWidth, 0.3, image),
            Text(username,
                style: TextStyle(
                    color: whitebg,
                    fontSize: textLG,
                    fontWeight: FontWeight.w500)),
            Container(
                margin: const EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(
                    vertical: paddingXSM / 2, horizontal: paddingSM),
                decoration: BoxDecoration(
                    color: whitebg,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Text(passRoleGeneral,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: textMD,
                        fontWeight: FontWeight.w500)))
          ]),
    );
  }
}

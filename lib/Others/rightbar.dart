import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';

class RightBar extends StatelessWidget {
  RightBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Drawer(
        backgroundColor: primaryColor,
        child: Container(
            width: fullWidth,
            margin: EdgeInsets.only(top: fullHeight * 0.075),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: marginMD),
                    child: Text("Notification",
                        style: TextStyle(
                            color: whitebg,
                            fontSize: textLG,
                            fontWeight: FontWeight.w500))),
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Text("Hari Ini",
                            style: TextStyle(
                                color: whitebg,
                                fontSize: textMD,
                                fontWeight: FontWeight.w500))),
                    Container(
                        margin: EdgeInsets.only(
                            bottom: paddingXSM,
                            left: paddingXSM,
                            right: paddingXSM),
                        padding: EdgeInsets.all(paddingSM),
                        decoration: BoxDecoration(
                          color: whitebg,
                          borderRadius: BorderRadius.all(roundedMd),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: fullWidth * 0.55, //Check this ...
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Fakultas Industri Kreatif",
                                            style: TextStyle(
                                                color: blackbg,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textSM + 1)),
                                        TextSpan(
                                            text:
                                                ' upload "Perkuliahan ganjil 2022/2023"',
                                            style: TextStyle(
                                                color: blackbg,
                                                fontSize: textSM + 1)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: marginMT * 0.4),
                                      child: Text("2 Jam yang lalu",
                                          style: TextStyle(
                                              color: greybg,
                                              fontSize: textSM + 1)))
                                ],
                              ),
                            ),
                            Container(
                              transform: Matrix4.translationValues(
                                  fullWidth * 0.525, 0.0, 0.0),
                              child: IconButton(
                                icon: Icon(Icons.chevron_right_rounded,
                                    color: primaryColor, size: 32),
                                tooltip: 'See Detail',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(
                            bottom: paddingXSM,
                            left: paddingXSM,
                            right: paddingXSM),
                        padding: EdgeInsets.all(paddingSM),
                        decoration: BoxDecoration(
                          color: whitebg,
                          borderRadius: BorderRadius.all(roundedMd),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: fullWidth * 0.55, //Check this ...
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Fakultas Industri Kreatif",
                                            style: TextStyle(
                                                color: blackbg,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textSM + 1)),
                                        TextSpan(
                                            text:
                                                ' upload "Perkuliahan ganjil 2022/2023"',
                                            style: TextStyle(
                                                color: blackbg,
                                                fontSize: textSM + 1)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: marginMT * 0.4),
                                      child: Text("2 Jam yang lalu",
                                          style: TextStyle(
                                              color: greybg,
                                              fontSize: textSM + 1)))
                                ],
                              ),
                            ),
                            Container(
                              transform: Matrix4.translationValues(
                                  fullWidth * 0.525, 0.0, 0.0),
                              child: IconButton(
                                icon: Icon(Icons.chevron_right_rounded,
                                    color: primaryColor, size: 32),
                                tooltip: 'See Detail',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ))
                  ],
                ))
              ],
            )));
  }
}

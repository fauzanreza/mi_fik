import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

import '../../../../Modules/Variables/global.dart';

class SetProfileImage extends StatefulWidget {
  @override
  _SetProfileImage createState() => _SetProfileImage();
}

class _SetProfileImage extends State<SetProfileImage> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(paddingMD),
          margin:
              EdgeInsets.fromLTRB(paddingMD, paddingLg, paddingMD, paddingMD),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: whitebg),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getTitleLarge("Profile Picture", primaryColor),
            Stack(
              children: [
                Container(
                  height: fullHeight * 0.25,
                  transform: Matrix4.translationValues(0.0, 15, 0.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: getImageUser(contentAttImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 5,
                    right: 10,
                    child: Container(
                        padding: EdgeInsets.all(paddingXSM * 0.8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: whitebg),
                            color: infoColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Image.asset('assets/icon/camera.png',
                              width: fullWidth * 0.085),
                        ))),
              ],
            )
          ]),
        )
      ],
    );
  }
}

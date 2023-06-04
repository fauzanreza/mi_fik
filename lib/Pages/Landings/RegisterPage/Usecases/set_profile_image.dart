import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetProfileImage extends StatefulWidget {
  const SetProfileImage({Key key}) : super(key: key);

  @override
  _SetProfileImage createState() => _SetProfileImage();
}

class _SetProfileImage extends State<SetProfileImage> {
  @override
  Widget build(BuildContext context) {
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
          ]),
        )
      ],
    );
  }
}

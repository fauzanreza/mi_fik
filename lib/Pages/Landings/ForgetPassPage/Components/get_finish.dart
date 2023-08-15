import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetFinish extends StatefulWidget {
  const GetFinish({Key key}) : super(key: key);

  @override
  StateGetFinish createState() => StateGetFinish();
}

class StateGetFinish extends State<GetFinish> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Container(
            height: fullHeight * 0.75,
            padding: EdgeInsets.symmetric(
                horizontal: spaceLG, vertical: spaceJumbo * 2),
            margin: EdgeInsets.fromLTRB(spaceLG, spaceJumbo, spaceLG, spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: getTitleLarge(
                        "Your account password has changed", primaryColor)),
                ClipRRect(
                  child: Image.asset('assets/icon/welcome_3.png',
                      width: fullHeight * 0.3),
                ),
                getSubTitleMedium(
                    "You can back to login page", darkColor, TextAlign.center),
              ],
            ))
      ],
    );
  }
}

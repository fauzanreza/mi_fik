import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetWaiting extends StatefulWidget {
  const GetWaiting({Key key}) : super(key: key);

  @override
  StateGetWaiting createState() => StateGetWaiting();
}

class StateGetWaiting extends State<GetWaiting> {
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
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.35),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            getTitleLarge("Your account has registered", primaryColor),
            ClipRRect(
              child: Image.asset('assets/icon/usermanage.png',
                  width: fullHeight * 0.3),
            ),
            getSubTitleMedium(
                "Please wait until your account has been approved by admin",
                darkColor,
                TextAlign.center)
          ]),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetWaiting extends StatefulWidget {
  const GetWaiting({Key key}) : super(key: key);

  @override
  _GetWaiting createState() => _GetWaiting();
}

class _GetWaiting extends State<GetWaiting> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Container(
          height: fullHeight * 0.75,
          padding: EdgeInsets.symmetric(
              horizontal: paddingMD, vertical: paddingLg * 2),
          margin:
              EdgeInsets.fromLTRB(paddingMD, paddingLg, paddingMD, paddingMD),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: whitebg),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            getTitleLarge("Your account has registered", primaryColor),
            ClipRRect(
              child: Image.asset('assets/icon/usermanage.png',
                  width: fullHeight * 0.3),
            ),
            getSubTitleMedium(
                "Please wait until your account has been approved by admin",
                blackbg,
                TextAlign.center)
          ]),
        )
      ],
    );
  }
}

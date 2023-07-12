import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key key}) : super(key: key);

  @override
  StateMaintenancePage createState() => StateMaintenancePage();
}

class StateMaintenancePage extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          // Do something LOL
          return false;
        },
        child: Scaffold(
            body: CustomPaint(
                painter: CirclePainterSide(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: spaceSM, horizontal: spaceLG),
                      margin: EdgeInsets.all(spaceLG * 2.5),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedLG)),
                      ),
                      child: ClipRRect(
                        child: Image.asset('assets/icon/maintenance.png'),
                      ),
                    ),
                    getTitleJumbo("Mi-FIK is under maintenance", whiteColor),
                    getTitleJumbo("We'll be back soon", whiteColor)
                  ],
                ))));
  }
}

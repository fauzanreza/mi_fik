import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key key}) : super(key: key);

  @override
  _MaintenancePage createState() => _MaintenancePage();
}

class _MaintenancePage extends State<MaintenancePage> {
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
                          vertical: paddingXSM, horizontal: paddingMD),
                      margin: EdgeInsets.all(paddingMD * 2.5),
                      decoration: BoxDecoration(
                        color: whitebg,
                        borderRadius: BorderRadius.all(roundedLG),
                      ),
                      child: ClipRRect(
                        child: Image.asset('assets/icon/maintenance.png'),
                      ),
                    ),
                    getTitleJumbo("Mi-FIK is under maintenance", whitebg),
                    getTitleJumbo("We'll be back soon", whitebg)
                  ],
                ))));
  }
}

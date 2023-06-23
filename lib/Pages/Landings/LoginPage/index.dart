import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/Usecases/post_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  StateLoginPage createState() => StateLoginPage();
}

class StateLoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: Scaffold(
            body: CustomPaint(
                painter: CirclePainterSide(),
                child: ListView(
                  children: [
                    const PostLogin(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: paddingXSM, horizontal: paddingMD),
                      margin: EdgeInsets.only(
                          left: fullWidth * 0.2,
                          right: fullWidth * 0.2,
                          top: 20,
                          bottom: 20),
                      decoration: BoxDecoration(
                        color: whitebg,
                        borderRadius: BorderRadius.all(roundedLG),
                      ),
                      child: ClipRRect(
                        child: Image.asset('assets/icon/fik_logo.png'),
                      ),
                    )
                  ],
                ))));
  }
}

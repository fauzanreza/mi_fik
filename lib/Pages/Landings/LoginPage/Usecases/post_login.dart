import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostLogin extends StatefulWidget {
  const PostLogin({Key key}) : super(key: key);

  @override
  _PostLogin createState() => _PostLogin();
}

class _PostLogin extends State<PostLogin> {
  var usernameCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  AuthCommandsService apiService;

  @override
  void dispose() {
    usernameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = AuthCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: paddingSM),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: fullHeight * 0.1),
      decoration: BoxDecoration(
        color: whitebg,
        borderRadius: BorderRadius.all(roundedLG),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: ClipRRect(
                child: Image.asset('assets/icon/mifik_logo.png', width: 300),
              ),
            ),
            Text("Username",
                style: TextStyle(color: blackbg, fontSize: textMD)),
            getInputText(lnameLength, usernameCtrl, false),
            Text("Password",
                style: TextStyle(color: blackbg, fontSize: textMD)),
            getInputText(passwordLength, passCtrl, true),
            Container(
                margin: EdgeInsets.only(top: paddingSM),
                padding: EdgeInsets.zero,
                width: fullWidth,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    LoginModel data = LoginModel(
                      username: usernameCtrl.text,
                      password: passCtrl.text,
                    );

                    //Validator
                    if (data.username.isNotEmpty && data.password.isNotEmpty) {
                      apiService.postLogin(data).then((response) {
                        setState(() => isLoading = false);
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBar()),
                          );
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "login"));

                          usernameCtrl.clear();
                          passCtrl.clear();
                        }
                      });
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => FailedDialog(
                              text: "Login failed, field can't be empty",
                              type: "login"));
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundedLG2),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                  child: const Text('Sign In'),
                ))
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';

class SignOutDialog extends StatefulWidget {
  const SignOutDialog({Key key}) : super(key: key);

  @override
  _SignOutDialog createState() => _SignOutDialog();
}

class _SignOutDialog extends State<SignOutDialog> {
  AuthQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = AuthQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      title: const Text('Warning'),
      content: SizedBox(
        width: fullWidth,
        height: 50,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Are you sure want to sign out?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: greybg, fontSize: textMD)))
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundedMd2),
            )),
            backgroundColor: MaterialStatePropertyAll<Color>(dangerColor),
          ),
          onPressed: () async {
            bool keyExists = await keyExist('token_key');

            if (keyExists) {
              apiService.getSignOut().then((response) {
                setState(() => isLoading = false);
                var body = response[0]['body'];
                var code = response[0]['code'];

                if (body == "Logout success" && code == 200) {
                  Get.to(() => const LoginPage());

                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          SuccessDialog(text: body));
                } else if (code == 401) {
                  Get.off(() => const LoginPage());

                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          SuccessDialog(text: "Sign out success"));
                } else {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          FailedDialog(text: body, type: "signout"));
                }
              });
            } else {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => FailedDialog(
                      text: "Sign out failed, token does't exist"));
              Get.to(() => const LoginPage());
            }
          },
          child: Text("Sign Out", style: TextStyle(color: whitebg)),
        )
      ],
    );
  }
}

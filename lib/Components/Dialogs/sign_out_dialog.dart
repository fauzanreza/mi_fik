import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SignOutDialog extends StatefulWidget {
  const SignOutDialog({Key key}) : super(key: key);

  @override
  StateSignOutDialog createState() => StateSignOutDialog();
}

class StateSignOutDialog extends State<SignOutDialog> {
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

    return AlertDialog(
      contentPadding: EdgeInsets.all(spaceSM),
      title: Text('Warning'.tr, style: TextStyle(fontSize: textXMD)),
      content: SizedBox(
        width: fullWidth,
        height: 50,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: spaceSM),
                  child: Text("Are you sure want to sign out?".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: shadowColor, fontSize: textXMD)))
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundedSM),
            )),
            backgroundColor: MaterialStatePropertyAll<Color>(warningBG),
          ),
          onPressed: () async {
            bool keyExists = await keyExist('token_key');

            if (keyExists) {
              await apiService.getSignOut().then((response) async {
                var body = response[0]['body'];
                var code = response[0]['code'];

                if (body == "Logout success" && code == 200) {
                  await getDestroyTrace(true);
                  Get.dialog(SuccessDialog(text: body));
                } else if (code == 401) {
                  await getDestroyTrace(true);
                  Get.dialog(SuccessDialog(text: "Sign out success".tr));
                } else {
                  Get.dialog(FailedDialog(text: body, type: "signout"));
                }
              });
            } else {
              await getDestroyTrace(true);
              Get.dialog(SuccessDialog(text: "Sign out success".tr));
            }
          },
          child: Text("Sign Out".tr,
              style: TextStyle(color: whiteColor, fontSize: textXMD)),
        )
      ],
    );
  }
}

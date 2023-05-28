import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/index.dart';

class PostSelectedRole extends StatefulWidget {
  const PostSelectedRole({Key key}) : super(key: key);

  @override
  _PostSelectedRole createState() => _PostSelectedRole();
}

class _PostSelectedRole extends State<PostSelectedRole> {
  UserCommandsService apiService;

  @override
  void initState() {
    super.initState();
    apiService = UserCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return ListView(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Back',
            onPressed: () {
              selectedRole.clear();
              Get.to(() => const RolePage());
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: paddingSM),
            child: TagSelectedArea(tag: selectedRole, type: "role")),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingSM),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    selectedRole.clear();
                    Get.to(() => const RolePage());
                  },
                  child: Container(
                    width: 105,
                    margin: EdgeInsets.only(top: paddingXSM),
                    padding: EdgeInsets.symmetric(
                        vertical: paddingXSM, horizontal: paddingXSM + 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: whitebg, width: 2),
                        color: dangerColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(Icons.restore, size: iconSM + 3, color: whitebg),
                        const Spacer(),
                        Text("Reset",
                            style: TextStyle(
                                fontSize: textMD,
                                fontWeight: FontWeight.w500,
                                color: whitebg))
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    AddNewReqModel data = AddNewReqModel(
                      reqType: "add",
                      userRole: validateNullJSON(selectedRole),
                    );

                    //Validator
                    if (data.userRole.isNotEmpty) {
                      apiService.postUserReq(data).then((response) {
                        setState(() => isLoading = false);
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.to(() => const BottomBar());
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  SuccessDialog(text: body));
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "req"));

                          setState(() {
                            selectedRole.clear();
                          });
                          Get.to(() => const RolePage());
                        }
                      });
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => FailedDialog(
                              text:
                                  "Request failed, you haven't chosen any tag yet",
                              type: "req"));
                    }
                  },
                  child: Container(
                    width: 110,
                    margin: EdgeInsets.only(top: paddingXSM),
                    padding: EdgeInsets.symmetric(
                        vertical: paddingXSM, horizontal: paddingXSM + 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: whitebg, width: 2),
                        color: successbg,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(Icons.send, size: iconSM + 3, color: whitebg),
                        const Spacer(),
                        Text("Submit",
                            style: TextStyle(
                                fontSize: textMD,
                                fontWeight: FontWeight.w500,
                                color: whitebg))
                      ],
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}

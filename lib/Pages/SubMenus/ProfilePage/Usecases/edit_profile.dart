import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class GetEditProfile extends StatefulWidget {
  const GetEditProfile({Key key}) : super(key: key);

  @override
  State<GetEditProfile> createState() => _GetEditProfileState();
}

class _GetEditProfileState extends State<GetEditProfile> {
  UserQueriesService apiQuery;
  UserCommandsService apiCommand;

  @override
  void initState() {
    super.initState();
    apiQuery = UserQueriesService();
    apiCommand = UserCommandsService();
  }

  var fNameCtrl = TextEditingController();
  var lNameCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  @override
  void dispose() {
    fNameCtrl.dispose();
    lNameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getMyProfile(),
        builder: (BuildContext context,
            AsyncSnapshot<List<UserProfileModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<UserProfileModel> contents = snapshot.data;

            return _buildListView(contents);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<UserProfileModel> contents) {
    if (contents != null) {
      fNameCtrl.text = contents[0].firstName;
      lNameCtrl.text = contents[0].lastName;
      passCtrl.text = contents[0].password;
      bool isLoading = false;

      return Theme(
          data: Theme.of(context).copyWith(
            dividerColor:
                Colors.transparent, // set the divider color to transparent
          ),
          child: SingleChildScrollView(
              child: ExpansionTile(
                  childrenPadding: EdgeInsets.only(
                      left: paddingSM, bottom: paddingSM, right: paddingSM),
                  initiallyExpanded: false,
                  trailing: Container(
                    padding: EdgeInsets.all(paddingXSM * 1),
                    decoration: BoxDecoration(
                      color: infoColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 3, color: whitebg),
                    ),
                    child: Icon(Icons.edit, color: whitebg),
                  ),
                  iconColor: null,
                  textColor: whitebg,
                  collapsedTextColor: primaryColor,
                  leading: null,
                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                  expandedAlignment: Alignment.topLeft,
                  title: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5, vertical: paddingSM),
                      child: Text("Edit Profile".tr,
                          style: TextStyle(
                              fontSize: textMD + 4,
                              fontWeight: FontWeight.w500))),
                  children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: getSubTitleMedium(
                        "First Name".tr, whitebg, TextAlign.start)),
                getInputText(fnameLength, fNameCtrl, false),
                Align(
                    alignment: Alignment.centerLeft,
                    child: getSubTitleMedium(
                        "Last Name".tr, whitebg, TextAlign.start)),
                getInputText(lnameLength, lNameCtrl, false),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: getSubTitleMedium(
                //         "Password".tr, whitebg, TextAlign.start)),
                // getInputText(passwordLength, passCtrl, true),
                InkWell(
                  onTap: () async {
                    EditUserProfileModel data = EditUserProfileModel(
                        lastName: lNameCtrl.text.trim(),
                        firstName: fNameCtrl.text.trim());

                    //Validator
                    if (data.firstName.isNotEmpty &&
                        data.lastName.isNotEmpty &&
                        data.firstName.length <= 35 &&
                        data.lastName.length <= 35) {
                      apiCommand.putProfileData(data).then((response) {
                        setState(() => isLoading = false);
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.to(() => const ProfilePage());
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  SuccessDialog(text: body));
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.back();
                          });
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "editacc"));
                        }
                      });
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => const FailedDialog(
                              text: "Edit failed, field can't be empty",
                              type: "editacc"));
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
                        Text("Submit".tr,
                            style: TextStyle(
                                fontSize: textMD,
                                fontWeight: FontWeight.w500,
                                color: whitebg))
                      ],
                    ),
                  ),
                )
              ])));
    } else {
      return const SizedBox();
    }
  }
}

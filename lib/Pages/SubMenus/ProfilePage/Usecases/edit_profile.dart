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
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

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
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<UserProfileModel> contents = snapshot.data;

            return _buildListView(contents);
          } else {
            return Center(
              child: Container(
                  margin: EdgeInsets.all(spaceMini),
                  padding: EdgeInsets.only(right: spaceMD),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 60,
                          width: 60,
                          borderRadius:
                              BorderRadius.all(Radius.circular(roundedMD))),
                    )
                  ])),
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

      return Theme(
          data: Theme.of(context).copyWith(
            dividerColor:
                Colors.transparent, // set the divider color to transparent
          ),
          child: SingleChildScrollView(
              child: ExpansionTile(
                  childrenPadding: EdgeInsets.only(
                      left: spaceXMD, bottom: spaceXMD, right: spaceXMD),
                  initiallyExpanded: false,
                  trailing: Container(
                    padding: EdgeInsets.all(spaceSM),
                    decoration: BoxDecoration(
                      color: infoBG,
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundedXLG)),
                      border: Border.all(width: 3, color: whiteColor),
                    ),
                    child: Icon(Icons.edit, color: whiteColor),
                  ),
                  iconColor: null,
                  textColor: whiteColor,
                  collapsedTextColor: primaryColor,
                  leading: null,
                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                  expandedAlignment: Alignment.topLeft,
                  title: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5, vertical: spaceXMD),
                      child: Text("Edit Profile".tr,
                          style: TextStyle(
                              fontSize: textXMD + 4,
                              fontWeight: FontWeight.w500))),
                  children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: getSubTitleMedium(
                        "First Name".tr, whiteColor, TextAlign.start)),
                getInputText(fnameLength, fNameCtrl, false),
                Align(
                    alignment: Alignment.centerLeft,
                    child: getSubTitleMedium(
                        "Last Name".tr, whiteColor, TextAlign.start)),
                getInputText(lnameLength, lNameCtrl, false),
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
                        setState(() => {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.toNamed(CollectionRoute.profile,
                              preventDuplicates: false);
                          Get.dialog(SuccessDialog(text: body));
                        } else {
                          Get.dialog(FailedDialog(text: body, type: "editacc"));
                        }
                      });
                    } else {
                      Get.dialog(const FailedDialog(
                          text: "Edit failed, field can't be empty",
                          type: "editacc"));
                    }
                  },
                  child: Container(
                    width: 110,
                    margin: EdgeInsets.only(top: spaceSM),
                    padding: EdgeInsets.symmetric(
                        vertical: spaceSM, horizontal: spaceSM + 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: whiteColor, width: 2),
                        color: successBG,
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedSM))),
                    child: Row(
                      children: [
                        Icon(Icons.send, size: iconSM + 3, color: whiteColor),
                        const Spacer(),
                        Text("Submit".tr,
                            style: TextStyle(
                                fontSize: textXMD,
                                fontWeight: FontWeight.w500,
                                color: whiteColor))
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

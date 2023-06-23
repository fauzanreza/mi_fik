import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class ShowRole extends StatefulWidget {
  const ShowRole({Key key}) : super(key: key);

  @override
  StateShowRole createState() => StateShowRole();
}

class StateShowRole extends State<ShowRole> {
  TagQueriesService queryService;
  UserCommandsService commandService;

  @override
  void initState() {
    super.initState();
    queryService = TagQueriesService();
    commandService = UserCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getMyTag(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MyTagModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<MyTagModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<MyTagModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    bool isLoading = false;
    double fullWidth = MediaQuery.of(context).size.width;

    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: mainbg, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(
                vertical: paddingXSM / 2, horizontal: paddingSM),
            childrenPadding: EdgeInsets.only(
                left: paddingSM, bottom: paddingSM, right: paddingSM),
            initiallyExpanded: false,
            iconColor: primaryColor,
            textColor: blackbg,
            leading: Icon(Icons.tag, size: iconLG),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            title: Text(ucFirst("My Roles".tr),
                style: TextStyle(fontSize: textMD - 1)),
            children: [
              Wrap(
                  runSpacing: -5,
                  spacing: 5,
                  children: contents.map<Widget>((tag) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        String removeText =
                            "Are you sure want to request remove".tr;
                        return showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              if (tag.slug != "lecturer" &&
                                  tag.slug != "student" &&
                                  tag.slug != "staff") {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(10),
                                  title: Text('Warning'.tr),
                                  content: SizedBox(
                                    width: fullWidth,
                                    height: 80,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                  "$removeText ${tag.tagName}?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: greybg,
                                                      fontSize: textMD)))
                                        ]),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(roundedMd2),
                                        )),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                dangerColor),
                                      ),
                                      onPressed: () async {
                                        selectedRole.add({
                                          "slug_name": tag.slug,
                                          "tag_name": tag.tagName
                                        });
                                        AddNewReqModel data = AddNewReqModel(
                                          reqType: "remove",
                                          userRole:
                                              validateNullJSON(selectedRole),
                                        );

                                        //Validator
                                        if (data.userRole.isNotEmpty) {
                                          commandService
                                              .postUserReq(data)
                                              .then((response) {
                                            setState(() => isLoading = false);
                                            var status = response[0]['message'];
                                            var body = response[0]['body'];

                                            if (status == "success") {
                                              Get.offAll(
                                                  () => const ProfilePage());
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SuccessDialog(
                                                              text: body));
                                            } else {
                                              Get.offAll(
                                                  () => const ProfilePage());

                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          FailedDialog(
                                                              text: body,
                                                              type: "req"));
                                            }
                                            setState(() {
                                              selectedRole.clear();
                                            });
                                          });
                                        } else {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  FailedDialog(
                                                      text:
                                                          "Request failed, you haven't chosen any tag yet"
                                                              .tr,
                                                      type: "req"));
                                        }
                                      },
                                      child: Text("Yes".tr,
                                          style: TextStyle(color: whitebg)),
                                    )
                                  ],
                                );
                              } else {
                                return FailedDialog(
                                    text:
                                        "Request failed, you can't remove general role"
                                            .tr,
                                    type: "req");
                              }
                            });
                      },
                      icon: Icon(
                        Icons.circle,
                        size: textSM,
                        color: Colors.green,
                      ),
                      label: Text(tag.tagName,
                          style: TextStyle(fontSize: textXSM)),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(roundedLG2),
                        )),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(primaryColor),
                      ),
                    );
                  }).toList()),
              Container(
                  padding: EdgeInsets.fromLTRB(0, paddingMD, 0, 0),
                  child: const GetInfoBox(
                    page: "profile",
                    location: "delete_role_mobile",
                  )),
              const Divider(thickness: 1.5)
            ]));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

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
    double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getMyTag(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MyTagModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<MyTagModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return Center(
              child: Container(
                  margin: EdgeInsets.all(spaceMini),
                  child: SkeletonLine(
                    style: SkeletonLineStyle(
                        height: 60,
                        width: fullWidth,
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedMini))),
                  )),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<MyTagModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hoverBG, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(
                vertical: spaceSM / 2, horizontal: spaceXMD),
            childrenPadding: EdgeInsets.only(
                left: spaceXMD, bottom: spaceXMD, right: spaceXMD),
            initiallyExpanded: false,
            iconColor: primaryColor,
            textColor: darkColor,
            leading: Icon(Icons.tag, size: iconLG),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            title: Text("My Roles".tr, style: TextStyle(fontSize: textXMD)),
            children: [
              contents != null
                  ? Wrap(
                      runSpacing: -spaceMini,
                      spacing: spaceMini,
                      children: contents.map<Widget>((tag) {
                        return ElevatedButton(
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
                                      contentPadding: EdgeInsets.all(spaceSM),
                                      title: Text('Warning'.tr,
                                          style: TextStyle(fontSize: textXMD)),
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
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: spaceSM),
                                                  child: Text(
                                                      "$removeText ${tag.tagName}?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: shadowColor,
                                                          fontSize: textXMD)))
                                            ]),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundedSM),
                                            )),
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    warningBG),
                                          ),
                                          onPressed: () async {
                                            selectedRole.clear();
                                            selectedRole.add({
                                              "slug_name": tag.slug,
                                              "tag_name": tag.tagName
                                            });
                                            AddNewReqModel data =
                                                AddNewReqModel(
                                              reqType: "remove",
                                              userRole: validateNullJSON(
                                                  selectedRole),
                                            );

                                            //Validator
                                            if (data.userRole.isNotEmpty) {
                                              commandService
                                                  .postUserReq(data)
                                                  .then((response) {
                                                setState(() => {});
                                                var status =
                                                    response[0]['message'];
                                                var body = response[0]['body'];

                                                if (status == "success") {
                                                  Get.toNamed(
                                                      CollectionRoute.profile,
                                                      preventDuplicates: false);
                                                  Get.dialog(SuccessDialog(
                                                      text: body));
                                                } else {
                                                  Get.toNamed(
                                                      CollectionRoute.profile,
                                                      preventDuplicates: false);

                                                  Get.dialog(FailedDialog(
                                                      text: body, type: "req"));
                                                }
                                                setState(() {
                                                  selectedRole.clear();
                                                });
                                              });
                                            } else {
                                              Get.dialog(FailedDialog(
                                                  text:
                                                      "Request failed, you haven't selected any tag yet"
                                                          .tr,
                                                  type: "req"));
                                            }
                                          },
                                          child: Text("Yes".tr,
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: textMD)),
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
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(roundedSM),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(primaryColor),
                          ),
                          child: Text(tag.tagName,
                              style: TextStyle(fontSize: textXSM)),
                        );
                      }).toList())
                  : Center(
                      child: getMessageImageNoData("assets/icon/nodata.png",
                          "Failed to get roles".tr, fullWidth)),
              const Divider(thickness: 1.5)
            ]));
  }
}

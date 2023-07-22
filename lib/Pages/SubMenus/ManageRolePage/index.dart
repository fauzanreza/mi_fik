import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/nodata_dialog.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_category.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/post_selected_role.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key key}) : super(key: key);

  @override
  StateRolePage createState() => StateRolePage();
}

class StateRolePage extends State<RolePage> {
  UserQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = UserQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getMyReq(true),
        builder: (BuildContext context,
            AsyncSnapshot<List<UserRequestModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<UserRequestModel> contents = snapshot.data;
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

  Widget _buildListView(List<UserRequestModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (contents == null) {
      return Scaffold(
        appBar: getAppbar("Manage Role".tr, () {
          selectedRole.clear();
          Get.to(() => const BottomBar());
        }),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: spaceXMD),
            child: const GetAllTagCategory(
              isLogged: true,
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedRole.isEmpty) {
              Get.dialog(
                  NoDataDialog(text: "You haven't selected any tag yet".tr));
            } else {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(roundedLG),
                        topRight: Radius.circular(roundedLG))),
                barrierColor: primaryColor.withOpacity(0.5),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                      height: fullHeight * 0.4,
                      padding: MediaQuery.of(context).viewInsets,
                      child: const PostSelectedRole(
                          back: RolePage(), isLogged: true));
                },
              );
            }
          },
          backgroundColor: successBG,
          tooltip: "Submit Changes".tr,
          child: const Icon(Icons.send),
        ),
      );
    } else {
      return Scaffold(
        appBar: getAppbar("Manage Role".tr, () {
          Get.back();
        }),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(spaceJumbo),
                height: fullHeight * 0.7,
                child: getMessageImageNoData(
                    "assets/icon/sorry.png",
                    "You can't request to modify your tag, because you still have Awaiting request. Please wait some moment or try to contact the Admin",
                    fullWidth))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(AlertDialog(
                insetPadding: EdgeInsets.all(spaceSM),
                contentPadding: EdgeInsets.all(spaceSM),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(roundedLG))),
                content: SizedBox(
                    height: fullHeight * 0.5,
                    width: fullWidth,
                    child: ListView(padding: EdgeInsets.zero, children: [
                      Row(children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: FaIcon(FontAwesomeIcons.clock,
                                    color: primaryColor, size: iconSM),
                              ),
                              TextSpan(
                                  text:
                                      " ${getItemTimeString(contents[0].createdAt)}",
                                  style: TextStyle(
                                      fontSize: textXMD, color: primaryColor))
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Back',
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ]),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: spaceMini),
                          child: Divider(
                              thickness: 1,
                              indent: spaceLG,
                              endIndent: spaceLG)),
                      getSubTitleMedium(
                          "You has requested to ${contents[0].type} tag",
                          darkColor,
                          TextAlign.center),
                      Wrap(
                          runSpacing: -spaceWrap,
                          spacing: spaceWrap,
                          alignment: WrapAlignment.center,
                          children: contents[0].tagSlugName.map<Widget>((tag) {
                            return ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(roundedSM),
                                )),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        primaryColor),
                              ),
                              child: Text(tag['tag_name'],
                                  style: TextStyle(fontSize: textXSM)),
                            );
                          }).toList())
                    ]))));
          },
          backgroundColor: successBG,
          tooltip: "See request".tr,
          child: const Icon(Icons.question_mark),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Components/Dialogs/nodata_dialog.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Services/queries.dart';
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
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
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
            child: const GetAllTagCategory()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedRole.isEmpty) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const NoDataDialog(
                      text: "You haven't selected any tag yet"));
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
            //
          },
          backgroundColor: successBG,
          tooltip: "Submit Changes".tr,
          child: const Icon(Icons.help_center),
        ),
      );
    }
  }
}

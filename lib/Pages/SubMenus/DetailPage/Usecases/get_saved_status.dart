import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetSavedStatus extends StatefulWidget {
  const GetSavedStatus({Key key, this.passSlug, this.ctx}) : super(key: key);
  final String passSlug;
  final String ctx;

  @override
  StateGetSavedStatus createState() => StateGetSavedStatus();
}

class StateGetSavedStatus extends State<GetSavedStatus> {
  ArchiveQueriesService apiService;
  bool found = false;

  @override
  void initState() {
    super.initState();
    apiService = ArchiveQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getMyArchive(widget.passSlug, widget.ctx),
        builder:
            (BuildContext context, AsyncSnapshot<List<ArchiveModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List<ArchiveModel> archieves = snapshot.data;

            for (var e in archieves) {
              if (e.found == 1) {
                found = true;
                break;
              }
            }

            return _buildListView(archieves);
          } else {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ArchiveModel> archieves) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    if (found) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: spaceSM, horizontal: spaceXMD),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.35),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
            color: successBG,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: RichText(
            text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(Icons.check, color: whiteColor, size: iconMD),
            ),
            TextSpan(
                text: " Saved".tr,
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: textSM + 1)),
          ],
        )),
      );
    } else {
      return const SizedBox();
    }
  }
}

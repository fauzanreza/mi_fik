import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Components/set_control.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key, this.item, this.isEmpty, this.isLoad})
      : super(key: key);
  final bool isEmpty;
  final List item;
  final bool isLoad;

  @override
  StateGetContent createState() => StateGetContent();
}

class StateGetContent extends State<GetContent> {
  ContentCommandsService commandService;

  @override
  void initState() {
    super.initState();
    commandService = ContentCommandsService();
  }

  //Initial variable
  final titleCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getActiveFilterText() {
      String order = "";
      String date = "";
      String title = "";
      String tags = "";

      // Title
      if (searchingContent.trim() != "") {
        String titleText = "Title like".tr;

        title = ', $titleText "$searchingContent"';
      }

      // Ordering
      if (sortingHomepageContent == "Desc") {
        order = "Descending".tr;
      } else {
        order = "Ascending".tr;
      }

      // Date filtering
      if (filterDateStart != null && filterDateEnd != null) {
        String filterText = "Start from".tr;
        String untilText = "until".tr;

        date =
            ", $filterText ${DateFormat("dd MMM yy").format(filterDateStart)} $untilText ${DateFormat("dd MMM yy").format(filterDateEnd)}";
      }

      // Tags
      if (selectedTagFilterContent.isNotEmpty) {
        int i = 0;
        int max = selectedTagFilterContent.length;
        for (var e in selectedTagFilterContent) {
          if (i == 0) {
            tags += ", ${e['tag_name']}, ";
          } else if (i == max - 1) {
            tags += "${e['tag_name']}";
          } else {
            tags += "${e['tag_name']}, ";
          }

          i++;
        }
      }

      String actvText = "Active filters".tr;
      String res = "$actvText : $order $date $title $tags";

      return Text(res.replaceAll("  ", " ").replaceAll(" ,", ", "),
          style: TextStyle(
              color: shadowColor,
              fontSize: textSM,
              fontWeight: FontWeight.w500));
    }

    int index = 1;
    return Container(
        margin: EdgeInsets.only(top: spaceLG),
        constraints: BoxConstraints(minHeight: fullHeight * 0.8),
        child: Column(children: [
          Container(
            transform: Matrix4.translationValues(0, -10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(spaceSM, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTitleLarge("What's New".tr, shadowColor),
                            getActiveFilterText(),
                          ],
                        ))),
                SetControl(titleCtrl: titleCtrl),
              ],
            ),
          ),
          widget.isEmpty == true
              ? SizedBox(
                  height: fullHeight * 0.7,
                  child: getMessageImageNoData(
                      "assets/icon/empty.png",
                      "No event / task for today, have a good rest".tr,
                      fullWidth))
              : widget.isLoad == false
                  ? Column(
                      children: widget.item.map<Widget>((e) {
                      if (index < widget.item.length + 1) {
                        if (index != widget.item.length) {
                          index++;
                          return _buildContentItem(e);
                        } else {
                          index++;
                          return Column(children: [
                            _buildContentItem(e),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: spaceLG),
                                child: Text("No more item to show".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: textMD)))
                          ]);
                        }
                      } else {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: spaceLG),
                            child: Text("No more item to show".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: textMD)));
                      }
                    }).toList())
                  : Column(
                      children: const [
                        SkeletonContentHeader(),
                        SkeletonContentHeader()
                      ],
                    )
        ]));
  }

  Widget _buildContentItem(ContentHeaderModel content) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: fullWidth,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.03),
                width: 2.5,
                color: primaryColor,
              ),
              GestureDetector(
                  onTap: () async {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult != ConnectivityResult.none) {
                      commandService
                          .postContentView(content.slugName)
                          .then((response) async {
                        setState(() {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.to(() => DetailPage(passSlug: content.slugName));
                        } else {
                          Get.dialog(
                              FailedDialog(text: body, type: "openevent"));
                        }
                      });
                    } else {
                      Get.to(() => DetailPage(passSlug: content.slugName));
                    }

                    passSlugContent = content.slugName;
                  },
                  child: GetHomePageEventContainer(
                      width: fullWidth,
                      content: content,
                      servc: commandService))
            ],
          ),
        ));
  }
}

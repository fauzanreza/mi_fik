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
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/set_control.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key, this.page}) : super(key: key);
  final int page;

  @override
  StateGetContent createState() => StateGetContent();
}

class StateGetContent extends State<GetContent> with TickerProviderStateMixin {
  ContentQueriesService queryService;
  ContentCommandsService commandService;

  //Initial variable
  final titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    queryService = ContentQueriesService();
    commandService = ContentCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getAllContentHeader(
            getTagFilterContent(selectedTagFilterContent),
            sortingHomepageContent,
            getWhereDateFilter(filterDateStart, filterDateEnd),
            getFindFilter(searchingContent),
            widget.page),
        builder: (BuildContext context,
            AsyncSnapshot<List<ContentHeaderModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentHeaderModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentHeaderModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getData(List<ContentHeaderModel> contents) {
      bool isLoading;
      if (contents != null) {
        return Container(
            constraints: BoxConstraints(minHeight: fullHeight * 0.8),
            child: Column(
                children: contents.map((content) {
              return SizedBox(
                  width: fullWidth,
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: fullWidth * 0.03),
                          width: 2.5,
                          color: primaryColor,
                        ),

                        // Open content w/ full container
                        GestureDetector(
                            onTap: () {
                              commandService
                                  .postContentView(content.slugName)
                                  .then((response) {
                                setState(() => isLoading = false);
                                var status = response[0]['message'];
                                var body = response[0]['body'];

                                if (status == "success") {
                                  Get.to(() =>
                                      DetailPage(passSlug: content.slugName));
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text: body, type: "openevent"));
                                }
                              });

                              passSlugContent = content.slugName;
                            },
                            child: GetHomePageEventContainer(
                                width: fullWidth,
                                content: content,
                                servc: commandService))
                      ],
                    ),
                  ));
            }).toList()));
      } else {
        return SizedBox(
            height: fullHeight * 0.7,
            child: getMessageImageNoData("assets/icon/nodata2.png",
                "Sorry but we not found specific event", fullWidth));
      }
    }

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
        selectedTagFilterContent.forEach((e) {
          if (i == 0) {
            tags += ", ${e['tag_name']}, ";
          } else if (i == max - 1) {
            tags += "${e['tag_name']}";
          } else {
            tags += "${e['tag_name']}, ";
          }

          i++;
        });
      }

      String actvText = "Active filters".tr;
      String res = "$actvText : $order $date $title $tags";

      return Text(res.replaceAll("  ", " ").replaceAll(" ,", ", "),
          style: TextStyle(
              color: greybg, fontSize: textSM, fontWeight: FontWeight.w500));
    }

    return Column(children: [
      Container(
        transform: Matrix4.translationValues(0, -10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(paddingXSM, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTitleLarge("What's New".tr, greybg),
                        getActiveFilterText(),
                      ],
                    ))),
            SetControl(titleCtrl: titleCtrl),
          ],
        ),
      ),
      getData(contents)
    ]);
  }
}

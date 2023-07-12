import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/delete_archive.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/edit_archive.dart';

class SavedContent extends StatefulWidget {
  const SavedContent({Key key, this.slug, this.name, this.desc})
      : super(key: key);
  final String slug;
  final String name;
  final String desc;

  @override
  StateSavedContent createState() => StateSavedContent();
}

class StateSavedContent extends State<SavedContent>
    with TickerProviderStateMixin {
  ArchiveQueriesService queryService;
  ContentCommandsService commandService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    setState(() {});
  }

  String hourChipBefore;

  @override
  void initState() {
    super.initState();
    queryService = ArchiveQueriesService();
    commandService = ContentCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getArchiveContent(widget.slug),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ScheduleModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ScheduleModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshData,
          child: ListView(
            padding: EdgeInsets.only(bottom: spaceJumbo),
            children: [
              Row(
                children: [
                  outlinedButtonCustom(() {
                    selectedArchiveSlug = null;
                    selectedArchiveName = null;
                    Get.offNamed(CollectionRoute.bar, preventDuplicates: false);
                  }, "Back to Archive".tr, Icons.arrow_back),
                  const Spacer(),
                  DeleteArchive(slug: widget.slug, name: widget.name),
                  EditArchive(
                      slug: widget.slug,
                      archiveName: widget.name,
                      archiveDesc: widget.desc)
                ],
              ),
              Column(
                  children: contents.map((content) {
                if (content.dataFrom == 1) {
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
                                onTap: () async {
                                  final connectivityResult =
                                      await (Connectivity()
                                          .checkConnectivity());
                                  if (connectivityResult !=
                                      ConnectivityResult.none) {
                                    commandService
                                        .postContentView(content.slugName)
                                        .then((response) {
                                      setState(() => {});
                                      var status = response[0]['message'];
                                      var body = response[0]['body'];

                                      if (status == "success") {
                                        Get.to(() => DetailPage(
                                            passSlug: content.slugName));
                                      } else {
                                        Get.dialog(FailedDialog(
                                            text: body, type: "openevent"));
                                      }
                                    });
                                  } else {
                                    Get.to(() =>
                                        DetailPage(passSlug: content.slugName));
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
                } else {
                  return SizedBox(
                      width: fullWidth,
                      child: IntrinsicHeight(
                          child: Stack(children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: fullWidth * 0.03),
                          width: 2.5,
                          color: primaryColor,
                        ),

                        // Open content w/ full container
                        GestureDetector(
                            onTap: () {
                              if (content.dataFrom == 2) {
                                showDialog<String>(
                                    context: context,
                                    barrierColor: primaryColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                            insetPadding:
                                                EdgeInsets.all(spaceSM),
                                            contentPadding:
                                                EdgeInsets.all(spaceSM),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        roundedLG))),
                                            content: DetailTask(
                                              data: content,
                                            ));
                                      });
                                    });
                              }
                            },
                            child: GetScheduleContainer(
                                width: fullWidth, content: content))
                      ])));
                }
              }).toList())
            ],
          ));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              outlinedButtonCustom(() {
                selectedArchiveSlug = null;
                selectedArchiveName = null;
                Get.offNamed(CollectionRoute.bar, preventDuplicates: false);
              }, "Back to Archive".tr, Icons.arrow_back),
              const Spacer(),
              DeleteArchive(slug: selectedArchiveSlug),
              EditArchive(
                slug: selectedArchiveSlug,
                archiveName: selectedArchiveName,
                archiveDesc: selectedArchiveDesc,
              )
            ],
          ),
          Container(
              alignment: Alignment.center,
              height: fullHeight * 0.7,
              child: getMessageImageNoData("assets/icon/nodata.png",
                  "No event / task saved in this archive".tr, fullWidth))
        ],
      );
    }
  }
}

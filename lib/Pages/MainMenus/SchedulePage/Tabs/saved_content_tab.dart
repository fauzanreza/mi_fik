import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/show_detail_task.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/delete_archive.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/edit_archive.dart';

class SavedContent extends StatefulWidget {
  SavedContent({Key key, this.slug, this.name, this.desc}) : super(key: key);
  String slug;
  String name;
  String desc;

  @override
  _SavedContent createState() => _SavedContent();
}

class _SavedContent extends State<SavedContent> with TickerProviderStateMixin {
  ArchiveQueriesService queryService;
  ContentCommandsService commandService;

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
    bool isLoading;

    Widget getUploadDate(date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final justNowHour = DateTime(now.hour);
      final justNowMinute = DateFormat("mm").format(now);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final content = DateTime(date.year, date.month, date.day);
      final contentHour = DateTime(date.hour);
      final contentMinute = DateFormat("mm").format(date);

      var result = "";

      if (content == today) {
        if (justNowHour == contentHour) {
          int diff = int.parse((justNowMinute).toString()) -
              int.parse((contentMinute).toString());
          if (diff > 10) {
            result = "$diff min ago";
          } else {
            result = "Just Now";
          }
        } else {
          result = "Today at ${DateFormat("HH:mm").format(date).toString()}";
        }
      } else if (content == yesterday) {
        result = "Yesterday at ${DateFormat("HH:mm").format(date).toString()}";
      } else {
        result = DateFormat("dd/MM/yy HH:mm").format(date).toString();
      }

      return Text(result,
          style: TextStyle(
            color: whitebg,
            fontWeight: FontWeight.w500,
          ));
    }

    if (contents != null) {
      return ListView(
        padding: EdgeInsets.only(bottom: paddingLg),
        children: [
          Row(
            children: [
              outlinedButtonCustom(() {
                selectedArchiveSlug = null;
                selectedArchiveName = null;
                Get.offAll(() => const BottomBar());
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
                                width: fullWidth, content: content))
                      ],
                    ),
                  ));
            } else {
              return SizedBox(
                  width: fullWidth,
                  child: IntrinsicHeight(
                      child: Stack(children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: fullWidth * 0.03),
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
                                            EdgeInsets.all(paddingXSM),
                                        contentPadding:
                                            EdgeInsets.all(paddingXSM),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.all(roundedLG)),
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
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              outlinedButtonCustom(() {
                selectedArchiveSlug = null;
                selectedArchiveName = null;
                Get.offAll(() => const BottomBar());
              }, "Back to Archive".tr, Icons.arrow_back),
              const Spacer(),
              DeleteArchive(slug: selectedArchiveSlug),
              EditArchive(
                  slug: selectedArchiveSlug, archiveName: selectedArchiveName)
            ],
          ),
          Container(
              alignment: Alignment.center,
              height: fullHeight * 0.7,
              child: getMessageImageNoData("assets/icon/nodata.png",
                  "No event / task saved in this archive", fullWidth))
        ],
      );
    }
  }
}

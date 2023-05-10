import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
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
  ArchiveQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ArchiveQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getArchiveContent(widget.slug),
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
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getUploadDate(date) {
      //Initial variable.
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

    if (contents.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    selectedArchiveSlug = null;
                    selectedArchiveName = null;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomBar()),
                    );
                  });
                },
                label: Text('Back to Archive',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: textMD,
                        fontWeight: FontWeight.w500)),
                icon: Icon(Icons.arrow_back, color: primaryColor),
                style: OutlinedButton.styleFrom(
                    // side: BorderSide(color: primaryColor),
                    ),
              ),
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
            return SizedBox(
                width: fullWidth,
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: fullWidth * 0.03),
                        width: 2.5,
                        color: primaryColor,
                      ),

                      //    CONTENT DOT????

                      // Container(
                      //   width: 20,
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: fullWidth * 0.01),
                      //   transform: Matrix4.translationValues(
                      //       0.0, -15.0, 0.0),
                      //   decoration: BoxDecoration(
                      //       color: mainbg,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(
                      //         color: primaryColor,
                      //         width: 2.5,
                      //       )),
                      // ),

                      //Open content w/ full container
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(passSlug: content.slugName)),
                          );

                          passSlugContent = content.slugName;
                        },
                        child: Container(
                            width: fullWidth * 0.82,
                            margin: EdgeInsets.only(bottom: marginMD),
                            transform:
                                Matrix4.translationValues(40.0, 5.0, 0.0),
                            decoration: BoxDecoration(
                              color: whitebg,
                              borderRadius: BorderRadius.all(roundedMd),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 128, 128, 128)
                                          .withOpacity(0.3),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(
                                    5.0,
                                    5.0,
                                  ),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 108.0,
                                  width: fullWidth,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: const AssetImage(
                                          'assets/icon/default_content.jpg'),
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        getUploadDate(
                                            DateTime.parse(content.dateStart))
                                      ]),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(content.contentTitle,
                                            style: TextStyle(
                                                color: blackbg,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textMD)),
                                        Text(
                                            removeHtmlTags(content.contentDesc),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: blackbg,
                                                fontSize: textSM))
                                      ]),
                                ),

                                //Open content w/ button.
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, 5.0, 0.0),
                                    padding: EdgeInsets.zero,
                                    width: fullWidth,
                                    height: 35,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  passSlug: content.slugName)),
                                        );

                                        passSlugContent = content.slugName;
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                primaryColor),
                                      ),
                                      child: const Text('Detail'),
                                    ))
                              ],
                            )),
                      )
                    ],
                  ),
                ));
          }).toList())
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    selectedArchiveName = null;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomBar()),
                    );
                  });
                },
                label: Text('Back to Archive',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: textMD,
                        fontWeight: FontWeight.w500)),
                icon: Icon(Icons.arrow_back, color: primaryColor),
                style: OutlinedButton.styleFrom(
                    // side: BorderSide(color: primaryColor),
                    ),
              ),
              const Spacer(),
              DeleteArchive(slug: selectedArchiveSlug),
              EditArchive(
                  slug: selectedArchiveSlug, archiveName: selectedArchiveName)
            ],
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Image.asset('assets/icon/nodata.png', width: fullWidth * 0.6),
                  Text("No Event/Task saved in this archive",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: textMD))
                ],
              ))
        ],
      );
    }
  }
}

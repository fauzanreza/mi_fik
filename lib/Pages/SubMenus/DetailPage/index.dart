import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Backgrounds/loading.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_attachment.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_location.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_saved_status.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/post_archive_rel.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.passSlug}) : super(key: key);
  final String passSlug;

  @override
  StateDetailPage createState() => StateDetailPage();
}

class StateDetailPage extends State<DetailPage> {
  ContentQueriesService apiQuery;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    apiQuery = ContentQueriesService();
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getContentDetail(widget.passSlug),
        builder: (BuildContext context,
            AsyncSnapshot<List<ContentDetailModel>> snapshot) {
          if (snapshot.hasError) {
            Get.dialog(const FailedDialog(
                text: "Unknown error, please contact the admin",
                type: "error"));
            return const Center(
              child: Text("Something wrong"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentDetailModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentDetailModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      //Convert date.
      Widget getContentDate(dateStart, dateEnd) {
        if (dateStart != null && dateEnd != null) {
          dateStart = DateTime.parse(dateStart)
              .add(Duration(hours: getUTCHourOffset()));
          dateEnd =
              DateTime.parse(dateEnd).add(Duration(hours: getUTCHourOffset()));

          //Initial variable.
          var monthStart = DateFormat("MM").format(dateStart).toString();
          var dayStart = DateFormat("dd").format(dateStart).toString();
          var yearStart = DateFormat("yyyy").format(dateStart).toString();
          var monthEnd = DateFormat("MM").format(dateEnd).toString();
          var dayEnd = DateFormat("dd").format(dateEnd).toString();
          var yearEnd = DateFormat("yyyy").format(dateEnd).toString();
          var result = "";

          if (yearStart == yearEnd) {
            if (monthStart == monthEnd) {
              if (dayStart == dayEnd) {
                result =
                    "$dayStart ${DateFormat("MMM").format(dateStart)} $yearStart";
              } else {
                result =
                    "$dayStart-$dayEnd ${DateFormat("MMM").format(dateStart)} $yearStart";
              }
            } else {
              result =
                  "$dayStart  ${DateFormat("MMM").format(dateStart)}-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearStart";
            }
          } else {
            result =
                "$dayStart  ${DateFormat("MMM").format(dateStart)} $yearStart-$dayEnd ${DateFormat("MMM").format(dateEnd)} $yearEnd";
          }
          return RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.calendar_month, size: 20, color: darkColor),
                ),
                TextSpan(
                    text: " $result",
                    style: TextStyle(color: darkColor, fontSize: textXMD))
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }

      //Get location name.
      Widget getLocation(loc, slug) {
        if (loc != null) {
          return LocationButton(passLocation: loc, passSlugName: slug);
        } else {
          return const SizedBox();
        }
      }

      //Get attachment file or link.
      Widget getAttach(attach, width) {
        if (attach != null && attach.isNotEmpty) {
          var listUrl = [];
          var listImage = [];
          var listVideo = [];
          var listDoc = [];

          attach.forEach((e) {
            if (e['attach_type'] == 'attachment_url') {
              listUrl.add(e);
            } else if (e['attach_type'] == 'attachment_image') {
              listImage.add(e);
            } else if (e['attach_type'] == 'attachment_video') {
              listVideo.add(e);
            } else if (e['attach_type'] == 'attachment_doc') {
              listDoc.add(e);
            }
          });

          var attachSorted = [...listUrl, ...listVideo, ...listDoc];

          return AttachButton(passAttach: attachSorted, passImage: listImage);
        } else {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: spaceXMD),
              child: getMessageImageNoData("assets/icon/attachment.png",
                  "This Event doesn't have attachment".tr, width));
        }
      }

      return WillPopScope(
          onWillPop: () {
            Get.toNamed(CollectionRoute.bar);
            return null;
          },
          child: Scaffold(
            backgroundColor: whiteColor,
            body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: refreshData,
                child: Stack(alignment: Alignment.center, children: [
                  ListView(
                      padding: const EdgeInsets.only(bottom: 75),
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          GestureDetector(
                            onTap: () => Get.dialog(
                              AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  content: SizedBox(
                                      height: fullHeight * 0.45,
                                      width: fullWidth,
                                      child: getContentImageHeader(
                                        contents[0].contentImage,
                                        fullWidth,
                                        fullHeight * 0.3,
                                        false,
                                        BorderRadius.all(
                                            Radius.circular(roundedMD)),
                                      ))),
                              barrierColor: primaryColor.withOpacity(0.5),
                            ),
                            child: SizedBox(
                              height: fullHeight * 0.3,
                              child: getContentImageHeader(
                                  contents[0].contentImage,
                                  fullWidth,
                                  fullHeight * 0.3,
                                  false,
                                  BorderRadius.zero),
                            ),
                          ),
                          Positioned(
                              right: 15,
                              bottom: 35,
                              child: GetSavedStatus(
                                  passSlug: widget.passSlug, ctx: "Event"))
                        ]),
                        Container(
                            transform:
                                Matrix4.translationValues(0.0, -20.0, 0.0),
                            padding: EdgeInsets.symmetric(vertical: spaceLG),
                            alignment: Alignment.topCenter,
                            constraints: BoxConstraints(
                              minHeight: fullHeight * 0.75,
                            ),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                            child: Column(children: [
                              Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: spaceSM),
                                padding: EdgeInsets.only(bottom: spaceMini),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    getProfileImage(
                                        contents[0].adminUsernameCreated,
                                        contents[0].userUsernameCreated,
                                        contents[0].adminImageCreated,
                                        contents[0].userImageCreated),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(ucAll(contents[0].contentTitle),
                                            style: TextStyle(
                                                fontSize: textXMD,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              getDescDetailWidget(
                                  contents[0].contentDesc, fullWidth),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: spaceXMD),
                                  child: Divider(
                                      thickness: 1,
                                      indent: spaceLG,
                                      endIndent: spaceLG)),
                              getAttach(contents[0].contentAttach, fullWidth),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: spaceXMD),
                                  child: Divider(
                                      thickness: 1,
                                      indent: spaceLG,
                                      endIndent: spaceLG)),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    spaceXMD, spaceXXSM, spaceXMD, 0),
                                child: getTag(contents[0].contentTag,
                                    fullHeight, contents),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.symmetric(horizontal: spaceXMD),
                                child: Wrap(
                                    runSpacing: spaceMini,
                                    spacing: spaceSM,
                                    children: [
                                      getLocation(contents[0].contentLoc,
                                          contents[0].slugName),
                                      getContentDate(contents[0].dateStart,
                                          contents[0].dateEnd),
                                      getContentHour(contents[0].dateStart,
                                          contents[0].dateEnd)
                                    ]),
                              ),
                            ])),
                      ]),
                  Positioned(
                    bottom: 10,
                    child: PostArchiveRelation(
                      passSlug: contents[0].slugName,
                      margin: EdgeInsets.symmetric(
                          horizontal: spaceXMD, vertical: spaceSM),
                      ctx: "Event",
                    ),
                  ),
                ])),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(top: spaceLG),
                decoration: BoxDecoration(
                    color: warningBG,
                    borderRadius:
                        BorderRadius.all(Radius.circular(roundedCircle))),
                child: FloatingActionButton(
                  backgroundColor: warningBG,
                  onPressed: () {},
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: iconLG),
                    color: whiteColor,
                    onPressed: () {
                      listArchiveCheck = [];
                      Get.toNamed(CollectionRoute.bar,
                          preventDuplicates: false);
                    },
                  ),
                )),
          ));
    } else {
      return WillPopScope(
          onWillPop: () {
            return Get.toNamed(CollectionRoute.bar, preventDuplicates: false);
          },
          child: Scaffold(
            body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: refreshData,
                child: Stack(alignment: Alignment.center, children: [
                  ListView(
                      padding: const EdgeInsets.only(bottom: 75),
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          GestureDetector(
                            onTap: () => showDialog<String>(
                              context: context,
                              barrierColor: primaryColor.withOpacity(0.5),
                              builder: (BuildContext context) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  content: Container(
                                    height: fullHeight * 0.45,
                                    width: fullWidth,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/icon/default_content.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(roundedSM),
                                    ),
                                  )),
                            ),
                            child: Container(
                              height: fullHeight * 0.3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icon/default_content.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 15,
                              bottom: 35,
                              child: GetSavedStatus(
                                  passSlug: widget.passSlug, ctx: "Event"))
                        ]),
                        Container(
                            transform:
                                Matrix4.translationValues(0.0, -20.0, 0.0),
                            padding: EdgeInsets.symmetric(vertical: spaceLG),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                            child: Center(
                                child: getMessageImageNoData(
                                    "assets/icon/badnet.png",
                                    "Failed to load data".tr,
                                    200))),
                      ]),
                ])),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(top: spaceLG),
                decoration: BoxDecoration(
                    color: warningBG,
                    borderRadius:
                        BorderRadius.all(Radius.circular(roundedCircle))),
                child: FloatingActionButton(
                  backgroundColor: warningBG,
                  onPressed: () {},
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: iconLG),
                    color: whiteColor,
                    onPressed: () {
                      Get.toNamed(CollectionRoute.bar,
                          preventDuplicates: false);
                    },
                  ),
                )),
          ));
    }
  }
}

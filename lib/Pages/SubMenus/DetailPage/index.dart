import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
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
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  ContentQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = ContentQueriesService();
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
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentDetailModel> contents = snapshot.data;
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

  Widget _buildListView(List<ContentDetailModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    //Convert date.
    Widget getContentDate(dateStart, dateEnd) {
      if (dateStart != null && dateEnd != null) {
        dateStart = DateTime.parse(dateStart);
        dateEnd = DateTime.parse(dateEnd);

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
                child: Icon(Icons.calendar_month, size: 20, color: blackbg),
              ),
              TextSpan(
                  text: " $result",
                  style: TextStyle(color: blackbg, fontSize: textMD))
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
    Widget getAttach(attach) {
      if (attach != null) {
        return AttachButton(passAttach: attach);
      } else {
        return const SizedBox();
      }
    }

    return WillPopScope(
        onWillPop: () {
          Get.offAll(() => const BottomBar());
        },
        child: Scaffold(
          body: Stack(alignment: Alignment.center, children: [
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
                                image: DecorationImage(
                                  image:
                                      getImageHeader(contents[0].contentImage),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(roundedLG2),
                              ),
                            )),
                      ),
                      child: Container(
                        height: fullHeight * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: getImageHeader(contents[0].contentImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 15,
                        bottom: 35,
                        child: GetSavedStatus(passSlug: widget.passSlug))
                  ]),
                  Container(
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      padding: EdgeInsets.symmetric(vertical: paddingMD),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getImageProfileContent(
                                  contents[0].adminUsernameCreated,
                                  contents[0].userUsernameCreated,
                                  contents[0].adminImageCreated,
                                  contents[0].userImageCreated),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contents[0].contentTitle,
                                      style: TextStyle(
                                          fontSize: textMD,
                                          fontWeight: FontWeight.bold)),
                                  //Check this...
                                  //getSubtitle(contents[0].contentSubtitle),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(horizontal: paddingSM),
                            child: HtmlWidget(contents[0].contentDesc)),
                        const SizedBox(height: 20),
                        getAttach(contents[0].contentAttach),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              paddingSM, paddingMD, paddingSM, 0),
                          child: getTag(
                              contents[0].contentTag, fullHeight, contents),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: paddingSM),
                          child: Wrap(runSpacing: 5, spacing: 10, children: [
                            getLocation(
                                contents[0].contentLoc, contents[0].slugName),
                            getContentDate(
                                contents[0].dateStart, contents[0].dateEnd),
                            getContentHour(
                                contents[0].dateStart, contents[0].dateEnd)
                          ]),
                        ),
                      ])),
                ]),
            Positioned(
              bottom: 10,
              child: PostArchiveRelation(
                passSlug: contents[0].slugName,
                margin: EdgeInsets.symmetric(
                    horizontal: paddingSM, vertical: paddingXSM),
                ctx: "Event",
              ),
            ),
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Container(
              margin: EdgeInsets.only(top: paddingMD),
              child: FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {},
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: iconLG),
                  color: whitebg,
                  onPressed: () {
                    listArchiveCheck = [];
                    Get.offAll(() => const BottomBar());
                  },
                ),
              )),
        ));
  }
}

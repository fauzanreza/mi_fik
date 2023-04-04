import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/Widget.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Services/Queries/ContentQueries.dart';
import 'package:mi_fik/Pages/SubMenus/Detail/Attach.dart';
import 'package:mi_fik/Pages/SubMenus/Detail/Location.dart';
import 'package:mi_fik/Pages/SubMenus/Detail/Save.dart';
import 'package:mi_fik/main.dart';

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
        future: apiQuery.getContent(widget.passSlug),
        builder:
            (BuildContext context, AsyncSnapshot<List<ContentModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentModel> contents = snapshot.data;
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

  Widget _buildListView(List<ContentModel> contents) {
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
                child:
                    Icon(Icons.calendar_month, size: 22, color: primaryColor),
              ),
              TextSpan(
                  text: result,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: textMD,
                      fontWeight: FontWeight.w500))
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    //Get location name.
    Widget getLocation(loc, id) {
      if (loc != null) {
        return LocationButton(passLocation: loc.toString(), passId: id);
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

    return Scaffold(
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              barrierColor: primaryColor.withOpacity(0.5),
              builder: (BuildContext context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  elevation: 0, //Remove shadow.
                  backgroundColor: Colors.transparent,
                  content: Container(
                    height: fullHeight * 0.45,
                    width: fullWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: getImageHeader(contents[0].contentImage),
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
          Container(
            transform: Matrix4.translationValues(
                fullWidth * 0.03, fullHeight * 0.03, 0.0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 67, 67, 67).withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                )
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: iconMD),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight * 0.28),
            height: fullHeight * 0.8,
            width: fullWidth,
            padding: EdgeInsets.only(top: paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(roundedLG2),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: iconLG,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                  "https://sci.telkomuniversity.ac.id/wp-content/uploads/2022/02/13.jpg")), //For now.
                        ),
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
                  Expanded(
                      child: ListView(padding: EdgeInsets.zero, children: [
                    //Content Description.
                    Container(
                        margin: EdgeInsets.only(
                            top: marginMT, left: marginMD, right: marginMD),
                        child: getDescHeaderWidget(contents[0].contentDesc)),
                    //Attached file or link.
                    getAttach(contents[0].contentAttach),
                    //Tag holder.
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: marginMT, horizontal: marginMD),
                      child:
                          getTag(contents[0].contentTag, fullHeight, contents),
                    ),
                  ])),
                  Container(
                    margin: EdgeInsets.only(
                        left: paddingXSM, right: paddingXSM, bottom: marginMD),
                    child: Wrap(runSpacing: -5, spacing: 10, children: [
                      // getLocation(
                      //     contents[0].contentLoc, int.parse(contents[0].id)),
                      getContentDate(
                          contents[0].dateStart, contents[0].dateEnd),
                      getContentHour(contents[0].dateStart, contents[0].dateEnd)
                    ]),
                  ),

                  //Save content to archieve.
                  SaveButton(passSlug: contents[0].slugName)
                ]),
          )
        ],
      ),
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/validator.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

Widget getUploadDateWidget(DateTime date) {
  //Initial variable.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final justNowHour = DateTime(now.hour);
  final justNowMinute = DateFormat("mm").format(now);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  date = DateTime.parse(
      getLocalConvertedDate(DateFormat('yyyy-MM-dd HH:mm:ss').format(date)));
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
    result = DateFormat("yyyy/MM/dd HH:mm").format(date).toString();
  }

  return Text(result,
      style: TextStyle(
        color: whiteColor,
        fontSize: textMD,
        fontWeight: FontWeight.w500,
      ));
}

Widget getViewWidget(total, u1, u2) {
  if (u1 == usernameKey || u2 == usernameKey) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.remove_red_eye, size: 14, color: whiteColor),
          ),
          TextSpan(text: " $total", style: TextStyle(color: whiteColor)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

getImageHeader(url) {
  if (url != null && url != "null" && url != "invalid") {
    return NetworkImage(url);
  } else if (url == "invalid") {
    return const AssetImage('assets/icon/default_failed_content.png');
  } else {
    return const AssetImage('assets/icon/default_content.jpg');
  }
}

Widget getContentImageHeader(
    String url, double width, double heigth, bool darken, BorderRadius rad) {
  getChild() {
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(darken ? 0.5 : 0), BlendMode.darken),
        child: FutureBuilder<bool>(
          future: isLoadable(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(
                    width: width, height: heigth, borderRadius: rad),
              );
            } else if (snapshot.hasData &&
                snapshot.data == true &&
                url != null &&
                url != "null") {
              return Image.network(
                url,
                width: width,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                height: heigth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        width: width, height: heigth, borderRadius: rad),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/icon/default_failed_content.png',
                    width: width,
                    height: heigth,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  );
                },
              );
            } else {
              return Image.asset(
                'assets/icon/default_content.jpg',
                width: width,
                height: heigth,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              );
            }
          },
        ));
  }

  return ClipRRect(
      borderRadius: rad,
      child: heigth != null
          ? LimitedBox(maxHeight: heigth, child: getChild())
          : getChild());
}

class GetContentVideo extends StatefulWidget {
  const GetContentVideo({Key key, this.url, this.width, this.height})
      : super(key: key);
  final String url;
  final double width;
  final double height;

  @override
  StateGetContentVideo createState() => StateGetContentVideo();
}

class StateGetContentVideo extends State<GetContentVideo> {
  VideoPlayerController controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url.toString())
      ..initialize().then((_) {
        setState(() {
          initialized = true;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? FutureBuilder<bool>(
            future: isLoadable(widget.url.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: widget.width,
                      height: widget.height,
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundedSM))),
                );
              } else if (snapshot.hasData && snapshot.data == true) {
                return AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: Chewie(
                      controller: ChewieController(
                          autoInitialize: true,
                          aspectRatio: controller.value.aspectRatio,
                          zoomAndPan: true,
                          fullScreenByDefault: false,
                          materialProgressColors: ChewieProgressColors(
                              playedColor: primaryColor,
                              handleColor: infoBG,
                              bufferedColor: primaryLightBG),
                          videoPlayerController: controller,
                          errorBuilder: (context, errorMessage) {
                            return Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  ClipRRect(
                                    child: Image.asset('assets/icon/Failed.png',
                                        height: 75),
                                  ),
                                  Text(
                                    errorMessage,
                                    style: TextStyle(
                                        color: whiteColor, fontSize: textMD),
                                  )
                                ]));
                          },
                          autoPlay: false,
                          looping: false,
                          allowFullScreen: false),
                    ));
              } else {
                return Container(
                    alignment: Alignment.center,
                    height: widget.height,
                    child: getMessageImageNoData("assets/icon/Failed.png",
                        "Failed to load video".tr, widget.height));
              }
            },
          )
        : SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: widget.width,
                height: widget.height,
                borderRadius: BorderRadius.all(Radius.circular(roundedSM))),
          );
  }
}

getImageUser(url) {
  if (url != null && url != "null") {
    return NetworkImage(url);
  } else {
    return const AssetImage('assets/icon/default_lecturer.png');
  }
}

Widget getDescHeaderWidget(String desc, Color clr, int maxLines) {
  if (desc != null && desc.trim() != "" && desc != "null") {
    return Expanded(
        child: Text(ucFirst(removeHtmlTags(desc).trim()),
            maxLines: maxLines,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: clr, fontSize: textSM)));
  } else {
    return Container(
        margin: EdgeInsets.only(top: spaceSM),
        child: Text("No description provided".tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: clr, fontSize: textSM, fontStyle: FontStyle.italic)));
  }
}

Widget getDescDetailWidget(String desc, double width) {
  if (desc != null && desc != "null") {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: spaceXMD),
        child: HtmlWidget(
          desc,
          onTapUrl: (p0) {
            return launchUrl(Uri.parse(p0.toString()));
          },
          onTapImage: (url) {
            Get.dialog(
              AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  content: SizedBox(
                    width: Get.width,
                    child: getContentImageHeader(
                        url.sources.first.url.toString(),
                        null,
                        null,
                        false,
                        BorderRadius.circular(roundedSM)),
                  )),
              barrierColor: primaryColor.withOpacity(0.5),
            );
            return null;
          },
          textStyle: const TextStyle(letterSpacing: 0.75),
          onLoadingBuilder: (context, element, loadingProgress) =>
              SkeletonParagraph(
            style: SkeletonParagraphStyle(
                lines: 6,
                spacing: spaceWrap,
                lineStyle: SkeletonLineStyle(
                  randomLength: true,
                  height: textSM,
                  borderRadius: BorderRadius.circular(8),
                  minLength: Get.width * 0.5,
                )),
          ),
          customStylesBuilder: (e) {
            if (e.localName == 'strong' || e.localName == 'a') {
              return {'color': '#F78A00', 'text-decoration': 'none'};
            }

            return null;
          },
          onErrorBuilder: (context, element, error) {
            return Container(
                margin: EdgeInsets.only(top: spaceSM),
                child: Text("Something wrong with description".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: textSM, fontStyle: FontStyle.italic)));
          },
        ));
  } else {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: spaceXMD),
        child: getMessageImageNoData("assets/icon/nodesc.png",
            "This Event doesn't have description".tr, width));
  }
}

Widget getContentLoc(loc) {
  if (loc != null) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.location_on, color: primaryColor, size: iconMD),
          ),
          TextSpan(
              text: getLocationName(loc),
              style: TextStyle(color: primaryColor, fontSize: textMD)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

Widget getTotalAttendance(int total, bool isShow) {
  if (isShow) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.person, color: primaryColor, size: iconMD),
          ),
          TextSpan(
              text: total.toString(),
              style: TextStyle(color: primaryColor, fontSize: textMD)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

Widget getTotalTag(tag) {
  if (tag != null) {
    int total = tag.length;

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.tag, color: primaryColor, size: iconMD - 2),
          ),
          TextSpan(
              text: "${total.toString()} ",
              style: TextStyle(color: primaryColor, fontSize: textMD)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

//Get content tag.
Widget getTag(tag, height, ctx) {
  int i = 0;
  int max = 10; //Maximum tag

  if (tag != null) {
    return Wrap(
        runSpacing: -spaceWrap,
        spacing: spaceWrap,
        children: tag.map<Widget>((content) {
          if (i < max) {
            i++;
            return ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedSM),
                )),
                backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
              ),
              child: Text(content['tag_name'],
                  style: TextStyle(fontSize: textXSM)),
            );
          } else if (i == max) {
            i++;
            return Container(
                margin: EdgeInsets.only(right: spaceSM),
                child: TextButton(
                  onPressed: () => Get.dialog(
                    AlertDialog(
                      contentPadding: EdgeInsets.all(spaceLG),
                      title: Text(
                        'All Tag'.tr,
                        style:
                            TextStyle(color: primaryColor, fontSize: textXMD),
                      ),
                      content: SizedBox(
                          width: height,
                          child: Wrap(
                              runSpacing: -spaceWrap,
                              spacing: spaceWrap,
                              children: tag.map<Widget>((content) {
                                return ElevatedButton(
                                  onPressed: () {
                                    // Respond to button press
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(roundedSM),
                                    )),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            primaryColor),
                                  ),
                                  child: Text(content['tag_name'],
                                      style: TextStyle(fontSize: textXSM)),
                                );
                              }).toList())),
                    ),
                  ),
                  child: Text(
                    "See ${tag.length - max} More",
                    style: TextStyle(color: primaryColor),
                  ),
                ));
          } else {
            return const SizedBox();
          }
        }).toList());
  } else {
    return const SizedBox();
  }
}

Widget getContentHour(dateStart, dateEnd) {
  if (dateStart != null && dateEnd != null) {
    return RichText(
      text: TextSpan(
        children: [
          //Content date start & end
          WidgetSpan(
            child: Icon(Icons.access_time, size: 20, color: darkColor),
          ),
          TextSpan(
              text:
                  " ${DateFormat("HH:mm").format(DateTime.parse(dateStart).add(Duration(hours: getUTCHourOffset())))} - ${DateFormat("HH:mm").format(DateTime.parse(dateEnd).add(Duration(hours: getUTCHourOffset())))}",
              style: TextStyle(color: darkColor, fontSize: textXMD)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

Widget getEventStatus(dateStart, dateEnd) {
  DateTime cStart = DateTime.parse(dateStart);
  DateTime cEnd = DateTime.parse(dateEnd);
  int offsetHours = getUTCHourOffset();
  Color clr;
  String ctx;

  cStart = cStart.add(Duration(hours: offsetHours));
  cEnd = cEnd.add(Duration(hours: offsetHours));

  DateTime now = DateTime.now();

  int msDiffStart = cStart.difference(now).inMilliseconds;
  int msDiffEnd = cEnd.difference(now).inMilliseconds;

  int hourDiffStart = (msDiffStart / (1000 * 60)).round();
  int hourDiffEnd = (msDiffEnd / (1000 * 60)).round();

  if (cStart.isAfter(now) &&
      cEnd.isAfter(now) &&
      hourDiffStart >= 0 &&
      hourDiffStart <= 15) {
    clr = primaryColor;
    ctx = " About to start".tr;
  } else if (cStart.isBefore(now) && cEnd.isAfter(now)) {
    clr = warningBG;
    if (hourDiffEnd > 1 && hourDiffStart > -15) {
      ctx = " Just started".tr;
    } else if (hourDiffEnd > 15) {
      ctx = " Live".tr;
    } else {
      ctx = " About to end".tr;
    }
  } else if (cStart.isBefore(now) &&
      cEnd.isBefore(now) &&
      hourDiffEnd <= 0 &&
      hourDiffEnd >= -15) {
    clr = successBG;
    ctx = " Just ended".tr;
  } else if (cStart.isBefore(now) && cEnd.isBefore(now) && hourDiffEnd <= -15) {
    clr = successBG;
    ctx = " Finished".tr;
  } else {
    return const SizedBox();
  }

  return Container(
      margin: EdgeInsets.only(left: spaceXLG * 0.8),
      padding: EdgeInsets.symmetric(horizontal: spaceSM, vertical: spaceMini),
      decoration: BoxDecoration(
          color: clr,
          borderRadius: BorderRadius.all(Radius.circular(roundedSM))),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                  margin: EdgeInsets.only(bottom: spaceMini - 1),
                  child:
                      Icon(Icons.circle, size: iconSM - 2, color: whiteColor)),
            ),
            TextSpan(
                text: ctx,
                style: TextStyle(
                    color: whiteColor,
                    fontSize: textXMD,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ));
}

Widget getEventDate(String dateStart, String dateEnd) {
  if (dateStart != null && dateEnd != null) {
    DateTime ds = DateTime.parse(dateStart);
    DateTime de = DateTime.parse(dateEnd);
    Duration offset = Duration(hours: getUTCHourOffset());
    String res = "";
    ds = ds.add(offset);
    de = de.add(offset);

    if (ds.year != de.year) {
      // Event year not the same
      res =
          "${getDateMonth(ds)} ${ds.year} ${getHourMinute(ds)} - ${getDateMonth(de)} ${de.year} ${getHourMinute(de)}";
    } else if (ds.month != de.month) {
      // If month not the same
      res =
          "${getDateMonth(ds)} ${ds.year} ${getHourMinute(ds)} - ${getDateMonth(de)} ${getHourMinute(de)}";
    } else if (ds.day != de.day) {
      // If date not the same
      res =
          "${getDateMonth(ds)} ${getHourMinute(ds)} - ${getDateMonth(de)} ${de.day.toString().padLeft(2, '0')} ${getHourMinute(de)}";
    } else if (ds.day == de.day) {
      res = "${getDateMonth(ds)} ${getHourMinute(ds)} - ${getHourMinute(de)}";
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              FontAwesomeIcons.clock,
              size: iconMD - 2,
              color: primaryColor,
            ),
          ),
          TextSpan(
              text: " $res",
              style: TextStyle(color: primaryColor, fontSize: textMD)),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}

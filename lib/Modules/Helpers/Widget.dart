import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Firebases/Storages/validator.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';
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

Widget getViewWidget(total) {
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

Widget getContentVideo(String url, double width, double heigth) {
  return FutureBuilder<bool>(
    future: isLoadable(url),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SkeletonAvatar(
          style: SkeletonAvatarStyle(
              width: width,
              height: heigth,
              borderRadius: BorderRadius.all(Radius.circular(roundedSM))),
        );
      } else if (snapshot.hasData && snapshot.data == true) {
        return AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(
              controller: ChewieController(
                  autoInitialize: true,
                  //aspectRatio: 16 / 9,
                  zoomAndPan: true,
                  fullScreenByDefault: false,
                  materialProgressColors: ChewieProgressColors(
                      playedColor: primaryColor,
                      handleColor: infoBG,
                      bufferedColor: primaryLightBG),
                  videoPlayerController: VideoPlayerController.network(
                    url.toString(),
                  ),
                  errorBuilder: (context, errorMessage) {
                    return Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          ClipRRect(
                            child: Image.asset('assets/icon/Failed.png',
                                height: 75),
                          ),
                          Text(
                            errorMessage,
                            style:
                                TextStyle(color: whiteColor, fontSize: textMD),
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
            height: heigth,
            child: getMessageImageNoData(
                "assets/icon/Failed.png", "Failed to load video".tr, heigth));
      }
    },
  );
}

getImageUser(url) {
  if (url != null && url != "null") {
    return NetworkImage(url);
  } else {
    return const AssetImage('assets/icon/default_lecturer.png');
  }
}

Widget getDescHeaderWidget(String desc, Color clr) {
  if (desc != null && desc.trim() != "" && desc != "null") {
    return Expanded(
        child: Text(ucFirst(removeHtmlTags(desc).trim()),
            maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: clr, fontSize: textSM)));
  } else {
    return Container(
        margin: EdgeInsets.only(top: spaceSM),
        child: Text("No description provided",
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
        child: HtmlWidget(desc));
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
            child: Icon(Icons.location_on, color: primaryColor, size: iconSM),
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

Widget getTotalTag(tag) {
  if (tag != null) {
    int total = tag.length;

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.tag, color: primaryColor, size: iconSM),
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
            return ElevatedButton.icon(
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(
                Icons.circle,
                size: textSM,
                color: Colors.green,
              ),
              label: Text(content['tag_name'],
                  style: TextStyle(fontSize: textXSM)),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedSM),
                )),
                backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
              ),
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
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    // Respond to button press
                                  },
                                  icon: Icon(
                                    Icons.circle,
                                    size: textSM,
                                    color: Colors.green,
                                  ),
                                  label: Text(content['tag_name'],
                                      style: TextStyle(fontSize: textXSM)),
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

Widget getPeriodDateWidget(dateStart, dateEnd) {
  //Initial variable.
  final now = DateTime.now();
  dateStart = DateTime.parse(dateStart);
  dateEnd = DateTime.parse(dateEnd);

  bool hasDatePassed(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }

  final ds = DateTime(dateStart.year, dateStart.month, dateStart.day,
      dateStart.hour, dateStart.minute);
  final de = DateTime(
      dateEnd.year, dateEnd.month, dateEnd.day, dateEnd.hour, dateEnd.minute);

  final isTodayStart =
      now.year == ds.year && now.month == ds.month && now.day == ds.day;
  final isTodayEnd =
      now.year == de.year && now.month == de.month && now.day == de.day;

  if (hasDatePassed(ds) && !hasDatePassed(de)) {
    if (now.difference(ds).inMinutes < 60 && isTodayStart) {
      return Container(
          margin: EdgeInsets.only(left: spaceXLG * 0.8),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.circle, size: 14, color: primaryColor),
                ),
                TextSpan(
                    text: " About to start",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: textXMD,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ));
    } else if (de.difference(now).inMinutes < 30 && isTodayEnd) {
      return Container(
          margin: EdgeInsets.only(left: spaceXLG * 0.8),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.circle, size: 14, color: warningBG),
                ),
                TextSpan(
                    text: " About to end",
                    style: TextStyle(
                        color: warningBG,
                        fontSize: textXMD,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ));
    } else {
      return Container(
          margin: EdgeInsets.only(left: spaceXLG * 0.8),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.circle, size: 14, color: warningBG),
                ),
                TextSpan(
                    text: "Live".tr,
                    style: TextStyle(
                        color: warningBG,
                        fontSize: textXMD,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ));
    }
  } else if (hasDatePassed(ds) && hasDatePassed(de)) {
    return Container(
        margin: EdgeInsets.only(left: spaceXLG * 0.8),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.circle, size: 14, color: successBG),
              ),
              TextSpan(
                  text: " Just Ended",
                  style:
                      TextStyle(color: successBG, fontWeight: FontWeight.w500)),
            ],
          ),
        ));
  } else {
    return const SizedBox();
  }
}

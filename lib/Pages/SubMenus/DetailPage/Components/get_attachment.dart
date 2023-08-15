import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Components/get_pdf.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages

class AttachButton extends StatefulWidget {
  const AttachButton({Key key, this.passAttach, this.passImage})
      : super(key: key);
  final List passAttach;
  final List passImage;

  @override
  StateAttachButton createState() => StateAttachButton();
}

class StateAttachButton extends State<AttachButton> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    // double fullHeigth = MediaQuery.of(context).size.height;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(left: spaceXLG),
        alignment: Alignment.centerLeft,
        child: getTitleLarge("Attachment".tr, primaryColor),
      ),
      widget.passImage.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: spaceXMD),
                      height: 280,
                      width: double.infinity,
                      child: PageView(
                        children: widget.passImage.map<Widget>(
                          (attach) {
                            return InkWell(
                                onTap: () => Get.dialog(
                                      AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          content: SizedBox(
                                            width: fullWidth,
                                            child: getContentImageHeader(
                                                attach['attach_url'].toString(),
                                                null,
                                                null,
                                                false,
                                                BorderRadius.circular(
                                                    roundedSM)),
                                          )),
                                      barrierColor:
                                          primaryColor.withOpacity(0.5),
                                    ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: spaceMini),
                                  width: fullWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      getContentImageHeader(
                                          attach['attach_url'].toString(),
                                          null,
                                          250,
                                          false,
                                          BorderRadius.circular(roundedSM)),
                                      const SizedBox(height: 5),
                                      Text(attach['attach_name'].toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: textSM,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic))
                                    ],
                                  ),
                                ));
                          },
                        ).toList(),
                        onPageChanged: (index) {
                          setState(() {
                            pageIndex = index;
                          });
                        },
                      )),
                  SizedBox(height: spaceMD),
                  CarouselIndicator(
                    count: widget.passImage.length,
                    index: pageIndex,
                    color: greyColor,
                    activeColor: primaryColor,
                  ),
                  SizedBox(height: spaceMD),
                ])
          : const SizedBox(),
      Column(
          children: widget.passAttach.map<Widget>((attach) {
        //Get button text by name or url.
        getButtonText(attach) {
          if (attach['attach_name'] != "") {
            return attach['attach_name'];
          } else {
            return attach['attach_url'];
          }
        }

        //Get button attachment by its type.
        getButton() {
          if (attach['attach_type'] == "attachment_url") {
            return RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.link, size: iconMD, color: primaryColor),
                  ),
                  TextSpan(
                      text: " ${getButtonText(attach)}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(attach['attach_url'].toString()));
                        },
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: darkColor,
                          fontSize: textSM + 2)),
                ],
              ),
            );
          } else if (attach['attach_type'] == "attachment_video") {
            return Transform(
                transform: Matrix4.translationValues(-spaceSM, 0.0, 0.0),
                child: GetContentVideo(
                    url: attach['attach_url'], width: fullWidth, height: 220));
          } else if (attach['attach_type'] == "attachment_doc") {
            return RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.picture_as_pdf,
                        size: iconLG, color: primaryColor),
                  ),
                  TextSpan(
                      text: " ${getButtonText(attach)}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(AttachmentDocPage(
                              url: attach['attach_url'].toString()));
                        },
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: darkColor,
                          fontSize: textSM + 2)),
                ],
              ),
            );
          }
        }

        return Container(
            margin: EdgeInsets.only(left: spaceXLG, top: spaceXLG * 0.3),
            alignment: Alignment.centerLeft,
            child: getButton());
      }).toList())
    ]);
  }
}

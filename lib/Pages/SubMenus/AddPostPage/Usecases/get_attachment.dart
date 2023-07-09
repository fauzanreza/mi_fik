import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/remove_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class GetFileAttachment extends StatefulWidget {
  const GetFileAttachment({Key key}) : super(key: key);

  @override
  State<GetFileAttachment> createState() => _GetFileAttachmentState();
}

class _GetFileAttachmentState extends State<GetFileAttachment> {
  DeleteImageContent fireServiceDelete;
  final attachmentURLCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fireServiceDelete = DeleteImageContent();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    int i = 0;

    resetItem(int idx) async {
      if (listAttachment[idx]["attach_url"].toString().isURL) {
        return await fireServiceDelete
            .deleteImageContent(listAttachment[idx]["attach_url"])
            .then((value) {
          if (value == true) {
            setState(() {
              listAttachment.removeAt(idx);
            });
            Get.snackbar("Alert".tr, "Attachment removed".tr,
                backgroundColor: whiteColor);
          } else {
            setState(() {
              listAttachment.removeAt(idx);
            });
            Get.snackbar("Alert".tr,
                "Attachment removed. Can't located uploaded file".tr,
                backgroundColor: whiteColor);
          }
        });
      } else {
        setState(() {
          listAttachment.removeAt(idx);
        });
        Get.snackbar("Alert".tr, "Attachment removed".tr,
            backgroundColor: whiteColor);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: listAttachment.map((e) {
        if (e['attach_type'] == "attachment_image") {
          return GetAttachmentContainer(
              data: e,
              others: null,
              action: () async {
                resetItem(i);
              },
              id: e['id'],
              item: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: spaceLG),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(e['attach_url'],
                          width: fullWidth * 0.5))));
        } else if (e['attach_type'] == "attachment_video") {
          return GetAttachmentContainer(
              data: e,
              others: null,
              id: e['id'],
              action: () async {
                resetItem(i);
              },
              item: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: spaceLG),
                  child: Chewie(
                    controller: ChewieController(
                      autoInitialize: true,
                      videoPlayerController:
                          VideoPlayerController.network(e['attach_url']),
                      autoPlay: false,
                      looping: false,
                      allowFullScreen: false,
                      materialProgressColors: ChewieProgressColors(
                          playedColor: primaryColor,
                          handleColor: infoBG,
                          bufferedColor: primaryLightBG),
                      errorBuilder: (context, errorMessage) {
                        return Text(
                          errorMessage,
                          style: TextStyle(color: darkColor),
                        );
                      },
                    ),
                  )));
        } else if (e['attach_type'] == "attachment_doc") {
          return GetAttachmentContainer(
              data: e,
              others: null,
              id: e['id'],
              action: () async {
                resetItem(i);
              },
              item: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: spaceLG),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.picture_as_pdf,
                              size: iconLG, color: primaryColor),
                        ),
                        TextSpan(
                            text: " PDF",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(AttachmentDocPage(
                                    url: e['attach_url'].toString()));
                              },
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: darkColor,
                                fontSize: textSM + 2)),
                      ],
                    ),
                  )));
        } else if (e['attach_type'] == "attachment_url") {
          return GetAttachmentContainer(
              data: e,
              item: const SizedBox(),
              id: e['id'],
              action: () {
                setState(() {
                  listAttachment.removeAt(i);
                });
                Get.snackbar("Alert".tr, "Attachment removed".tr,
                    backgroundColor: whiteColor);
              },
              others: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSubTitleMedium(
                      "Attachment URL".tr, darkColor, TextAlign.start),
                  getInputTextAtt(75, e['id'], 'attach_url'),
                ],
              ));
        }
        i++;
      }).toList(),
    );
  }
}

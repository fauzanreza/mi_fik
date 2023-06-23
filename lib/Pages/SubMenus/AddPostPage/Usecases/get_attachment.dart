import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/remove_image.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
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
    bool isLoading;
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
                backgroundColor: whitebg);
          } else {
            setState(() {
              listAttachment.removeAt(idx);
            });
            Get.snackbar("Alert".tr,
                "Attachment removed. Can't located uploaded file".tr,
                backgroundColor: whitebg);
          }
        });
      } else {
        setState(() {
          listAttachment.removeAt(idx);
        });
        Get.snackbar("Alert".tr, "Attachment removed".tr,
            backgroundColor: whitebg);
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
                  margin: EdgeInsets.symmetric(vertical: paddingMD),
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
                  margin: EdgeInsets.symmetric(vertical: paddingMD),
                  child: Chewie(
                    controller: ChewieController(
                      videoPlayerController:
                          VideoPlayerController.network(e['attach_url']),
                      autoPlay: false,
                      looping: false,
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
                    backgroundColor: whitebg);
              },
              others: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSubTitleMedium(
                      "Attachment URL".tr, blackbg, TextAlign.start),
                  getInputTextAtt(75, e['id'], 'attach_url'),
                ],
              ));
        }
        i++;
      }).toList(),
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Container/content.dart';
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

  @override
  void initState() {
    super.initState();
    fireServiceDelete = DeleteImageContent();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    Widget getListAttTitle(List arr) {
      if (arr.isNotEmpty) {
        return Container(
            margin: EdgeInsets.all(paddingMD),
            child: Text('List Attachment', style: TextStyle(fontSize: textMD)));
      } else {
        return SizedBox();
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      getListAttTitle(listAttachment),
      Column(
          children: listAttachment.map((e) {
        if (e['attach_type'] == "attachment_image") {
          return GetAttachmentContainer(
              data: e,
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
          return Container();
        }
      }).toList()),
    ]);
  }
}

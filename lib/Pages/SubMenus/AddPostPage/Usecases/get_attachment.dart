import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Firebases/Storages/Content/remove_image.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetFileAttachment extends StatefulWidget {
  const GetFileAttachment({Key key}) : super(key: key);

  @override
  State<GetFileAttachment> createState() => _GetFileAttachmentState();
}

class _GetFileAttachmentState extends State<GetFileAttachment> {
  DeleteImageContent fireServiceDelete;
  var attachmentNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fireServiceDelete = DeleteImageContent();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading;

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          margin: EdgeInsets.all(paddingMD),
          child: Text('List Attachment', style: TextStyle(fontSize: textMD))),
      Column(
          children: listAttachment.map((e) {
        if (e['attach_type'] == "attachment_image") {
          return Container(
            width: fullWidth * 0.9,
            alignment: Alignment.center,
            padding: EdgeInsets.all(paddingSM),
            margin: EdgeInsets.only(bottom: paddingMD),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //     topRight: Radius.circular(paddingMD),
                //     bottomRight: Radius.circular(paddingMD)),
                border: Border(
                    left: BorderSide(width: 4, color: successbg),
                    right: BorderSide(width: 1.5, color: greybg),
                    top: BorderSide(width: 1.5, color: greybg),
                    bottom: BorderSide(width: 1.5, color: greybg))),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ExpansionTile(
                      childrenPadding: EdgeInsets.only(
                          left: paddingSM, bottom: paddingSM, right: paddingSM),
                      initiallyExpanded: false,
                      trailing:
                          Icon(Icons.remove_red_eye_outlined, color: blackbg),
                      iconColor: null,
                      textColor: whitebg,
                      collapsedTextColor: primaryColor,
                      leading: null,
                      expandedCrossAxisAlignment: CrossAxisAlignment.end,
                      expandedAlignment: Alignment.topLeft,
                      tilePadding: EdgeInsets.zero,
                      title: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: paddingSM),
                          child: getSubTitleMedium(
                              "Attachment Type : ${ucFirst(getSeparatedAfter("_", e['attach_type']))}",
                              blackbg)),
                      children: [
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: paddingMD),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(e['attach_url'],
                                    width: fullWidth * 0.5))),
                      ]),
                  getSubTitleMedium("Attachment Name", blackbg),
                  getInputText(75, attachmentNameCtrl, false),
                ])),
          );
        } else if (e['attach_type'] == "attachment_video") {
          return Container();
        } else if (e['attach_type'] == "attachment_url") {
          return Container();
        }
      }).toList()),
    ]);
  }
}

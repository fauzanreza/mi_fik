import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Firebases/Storages/validator.dart';
import 'package:pdfx/pdfx.dart';
import 'package:skeletons/skeletons.dart';

class AttachmentDocPage extends StatefulWidget {
  const AttachmentDocPage({Key key, this.url}) : super(key: key);
  final String url;

  @override
  StateAttachmentDocPage createState() => StateAttachmentDocPage();
}

class StateAttachmentDocPage extends State<AttachmentDocPage> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("Attachment Document".tr, () {
          Get.back();
        }),
        body: FutureBuilder<bool>(
          future: isLoadable(widget.url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: EdgeInsets.only(top: fullHeight * 0.2),
                child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        width: fullWidth, height: fullHeight * 0.5)),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              final pdfController = PdfController(
                  document: PdfDocument.openData(InternetFile.get(widget.url)));

              return PdfView(
                scrollDirection: Axis.vertical,
                controller: pdfController,
                renderer: (PdfPage page) => page.render(
                  width: page.width * 2,
                  height: page.height * 2,
                  format: PdfPageImageFormat.png,
                  backgroundColor: '#FFFFFF',
                ),
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: fullHeight * 0.2),
                  height: fullHeight * 0.5,
                  child: getMessageImageNoData("assets/icon/Failed.png",
                      "Failed to load document".tr, fullWidth));
            }
          },
        ));
  }
}

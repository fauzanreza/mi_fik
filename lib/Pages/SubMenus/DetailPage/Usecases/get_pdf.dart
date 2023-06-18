import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:pdfx/pdfx.dart';

class AttachmentDocPage extends StatefulWidget {
  const AttachmentDocPage({Key key, this.url}) : super(key: key);
  final String url;

  @override
  StateAttachmentDocPage createState() => StateAttachmentDocPage();
}

class StateAttachmentDocPage extends State<AttachmentDocPage> {
  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(widget.url)));

    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("Attachment Document".tr, () {
          Get.back();
        }),
        body: PdfView(
          scrollDirection: Axis.vertical,
          controller: pdfController,
          renderer: (PdfPage page) => page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          ),
        ));
  }
}

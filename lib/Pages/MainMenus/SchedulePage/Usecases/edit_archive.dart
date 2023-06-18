import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class EditArchive extends StatefulWidget {
  const EditArchive({Key key, this.slug, this.archiveName, this.archiveDesc})
      : super(key: key);
  final String slug;
  final String archiveName;
  final String archiveDesc;

  @override
  StateEditArchive createState() => StateEditArchive();
}

class StateEditArchive extends State<EditArchive> {
  ArchiveCommandsService apiService;
  final archiveNameCtrl = TextEditingController();
  final archiveDescCtrl = TextEditingController();

  @override
  void dispose() {
    archiveNameCtrl.dispose();
    archiveDescCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = ArchiveCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return IconButton(
      icon: const Icon(Icons.edit),
      color: primaryColor,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: false,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(topLeft: roundedLG, topRight: roundedLG)),
          barrierColor: primaryColor.withOpacity(0.5),
          isScrollControlled: true,
          builder: (BuildContext context) {
            archiveNameCtrl.text = widget.archiveName;
            archiveDescCtrl.text = widget.archiveDesc;

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Back',
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Text("Edit Archive".tr,
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: textLG)),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
                      child: Text("Archive Name".tr,
                          style: TextStyle(color: blackbg, fontSize: textMD))),
                  Container(
                      padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
                      child: getInputText(75, archiveNameCtrl, false)),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
                      child: Text("Description (optional)".tr,
                          style: TextStyle(color: blackbg, fontSize: textMD))),
                  Container(
                      padding: EdgeInsets.fromLTRB(
                          paddingSM, 10, paddingSM, paddingMD * 2),
                      child: getInputDesc(255, 3, archiveDescCtrl, false)),
                  SizedBox(
                      width: fullWidth,
                      height: btnHeightMD,
                      child: ElevatedButton(
                        onPressed: () async {
                          EditArchiveModel archive = EditArchiveModel(
                              archiveName: archiveNameCtrl.text.trim(),
                              archiveDesc: archiveDescCtrl.text.trim(),
                              archiveNameOld: widget.archiveName);

                          if (archive.archiveName.isNotEmpty) {
                            apiService
                                .editArchive(archive, widget.slug)
                                .then((response) {
                              setState(() => isLoading = false);
                              var status = response[0]['message'];
                              var body = response[0]['body'];

                              if (status == "success") {
                                selectedArchiveName = archive.archiveName;
                                selectedArchiveDesc = archive.archiveDesc;
                                Get.offAll(() => const BottomBar());

                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SuccessDialog(text: body));
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        FailedDialog(
                                            text: body, type: "addarchive"));
                              }
                            });
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    const FailedDialog(
                                        text:
                                            "Edit archive failed, field can't be empty"));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(successbg),
                        ),
                        child: Text('Done'.tr),
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}

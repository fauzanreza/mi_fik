import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostArchive extends StatefulWidget {
  const PostArchive({Key key, this.text}) : super(key: key);
  final String text;

  @override
  StatePostArchive createState() => StatePostArchive();
}

class StatePostArchive extends State<PostArchive> {
  ArchiveCommandsService archiveService;
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
    archiveService = ArchiveCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Back',
              onPressed: () {
                archiveNameCtrl.clear();
                Get.back();
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              alignment: Alignment.centerLeft,
              child: getTitleLarge("New Archive".tr, primaryColor)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: Text("Archive Name".tr,
                  style: TextStyle(color: darkColor, fontSize: textXMD))),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, 0),
              child: getInputWarning(archiveNameMsg)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: getInputText(75, archiveNameCtrl, false)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, 0),
              child: getInputWarning(archiveDescMsg)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
              child: Text("Description (optional)".tr,
                  style: TextStyle(color: darkColor, fontSize: textXMD))),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, spaceLG * 2),
              child: getInputDesc(255, 3, archiveDescCtrl, false)),
          Container(
              padding: EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, 0),
              child: getInputWarning(allArchiveMsg)),
          SizedBox(
              // transform: Matrix4.translationValues(
              //     0.0, fullHeight * 0.94, 0.0),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  AddArchiveModel archive = AddArchiveModel(
                      archiveName: archiveNameCtrl.text.trim(),
                      archiveDesc: validateNull(archiveDescCtrl.text.trim()));

                  //Validator
                  if (archive.archiveName.isNotEmpty) {
                    archiveService.addArchive(archive).then((response) {
                      setState(() => {});
                      var status = response[0]['message'];
                      var body = response[0]['body'];

                      if (status == "success") {
                        Get.offNamed(CollectionRoute.bar,
                            preventDuplicates: false);
                        Get.dialog(SuccessDialog(text: body));
                      } else {
                        archiveNameMsg = "";
                        archiveDescMsg = "";
                        allArchiveMsg = "";

                        Get.back();
                        Get.dialog(
                            FailedDialog(text: body, type: "addarchive"));
                        setState(() {
                          if (body is! String) {
                            if (body['archive_name'] != null) {
                              archiveNameMsg = body['archive_name'][0];

                              if (body['archive_name'].length > 1) {
                                for (String e in body['archive_name']) {
                                  archiveNameMsg += e;
                                }
                              }
                            }

                            if (body['archive_desc'] != null) {
                              archiveDescMsg = body['archive_desc'][0];

                              if (body['archive_desc'].length > 1) {
                                for (String e in body['archive_desc']) {
                                  archiveDescMsg += e;
                                }
                              }
                            }
                          } else {
                            allArchiveMsg = body;
                          }
                        });
                      }
                    });
                  } else {
                    Get.back();
                    Get.dialog(const FailedDialog(
                        text: "Create archive failed, field can't be empty",
                        type: "addarchive"));
                    allArchiveMsg =
                        "Create archive failed, field can't be empty";
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(successBG),
                ),
                child: Text('Done'.tr, style: TextStyle(fontSize: textXMD)),
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DeleteArchive extends StatefulWidget {
  const DeleteArchive({Key key, this.slug, this.name}) : super(key: key);
  final String slug;
  final String name;

  @override
  StateDeleteArchive createState() => StateDeleteArchive();
}

class StateDeleteArchive extends State<DeleteArchive> {
  ArchiveCommandsService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ArchiveCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return IconButton(
      icon: const Icon(Icons.delete),
      color: warningBG,
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    insetPadding: EdgeInsets.all(spaceXMD),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: spaceLG, vertical: spaceLG * 1.5),
                    content: SizedBox(
                        height: 120,
                        width: fullWidth,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Are you sure want to delete this archive, all event related to this archive also will be deleted",
                                  style: TextStyle(
                                      color: darkColor,
                                      fontSize: textXMD,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            warningBG.withOpacity(0.8),
                                        padding: EdgeInsets.all(spaceLG * 0.8)),
                                    onPressed: () async {
                                      DeleteArchiveModel archive =
                                          DeleteArchiveModel(
                                              archiveName: widget.name);

                                      apiService
                                          .deleteArchive(archive, widget.slug)
                                          .then((response) {
                                        setState(() => {});
                                        var status = response[0]['message'];
                                        var body = response[0]['body'];

                                        if (status == "success") {
                                          selectedArchiveSlug = null;
                                          selectedArchiveName = null;
                                          selectedArchiveDesc = null;
                                          Get.toNamed(CollectionRoute.bar,
                                              preventDuplicates: false);
                                          Get.dialog(SuccessDialog(text: body));
                                        } else {
                                          Get.dialog(FailedDialog(
                                              text: body, type: "addarchive"));
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Yes, Delete archive".tr,
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.all(spaceLG * 0.8)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Cancel".tr,
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ])));
              });
            });
      },
    );
  }
}

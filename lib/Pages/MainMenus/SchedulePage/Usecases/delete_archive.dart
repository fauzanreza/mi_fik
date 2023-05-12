import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DeleteArchive extends StatefulWidget {
  DeleteArchive({Key key, this.slug, this.name}) : super(key: key);
  String slug;
  String name;

  @override
  _DeleteArchive createState() => _DeleteArchive();
}

class _DeleteArchive extends State<DeleteArchive> {
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
    bool isLoading = false;

    return IconButton(
      icon: const Icon(Icons.delete),
      color: dangerColor,
      onPressed: () {
        return showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    insetPadding: EdgeInsets.all(paddingSM),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: paddingMD, vertical: paddingMD * 1.5),
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
                                      color: blackbg,
                                      fontSize: textMD,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            dangerColor.withOpacity(0.8),
                                        padding:
                                            EdgeInsets.all(paddingMD * 0.8)),
                                    onPressed: () async {
                                      DeleteArchiveModel archive =
                                          DeleteArchiveModel(
                                              archiveName: widget.name);

                                      apiService
                                          .deleteArchive(archive, widget.slug)
                                          .then((response) {
                                        setState(() => isLoading = false);
                                        var status = response[0]['message'];
                                        var body = response[0]['body'];

                                        if (status == "success") {
                                          selectedArchiveSlug = null;
                                          selectedArchiveName = null;
                                          selectedArchiveDesc = null;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomBar()),
                                          );
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SuccessDialog(text: body));
                                        } else {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  FailedDialog(
                                                      text: body,
                                                      type: "addarchive"));
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Yes, Delete archive",
                                      style: TextStyle(
                                        color: whitebg,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding:
                                            EdgeInsets.all(paddingMD * 0.8)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: whitebg,
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

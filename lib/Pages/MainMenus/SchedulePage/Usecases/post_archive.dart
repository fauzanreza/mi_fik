import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Modules/Models/Archive/Archive.dart';
import 'package:mi_fik/Modules/Services/ArchieveServices.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class PostArchive extends StatefulWidget {
  PostArchive({Key key, this.text}) : super(key: key);
  String text;

  @override
  _PostArchive createState() => _PostArchive();
}

class _PostArchive extends State<PostArchive> {
  ArchieveService archiveService;
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
    archiveService = ArchieveService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

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
                Navigator.pop(context);
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: Text("New Archive",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: textLG))),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: Text("Archive Name",
                  style: TextStyle(color: blackbg, fontSize: textMD))),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: getInputText(75, archiveNameCtrl, false)),
          Container(
              padding: EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
              child: Text("Description (optional)",
                  style: TextStyle(color: blackbg, fontSize: textMD))),
          Container(
              padding:
                  EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, paddingMD * 2),
              child: getInputDesc(255, 3, archiveDescCtrl, false)),
          SizedBox(
              // transform: Matrix4.translationValues(
              //     0.0, fullHeight * 0.94, 0.0),
              width: fullWidth,
              height: btnHeightMD,
              child: ElevatedButton(
                onPressed: () async {
                  //Mapping.
                  ArchiveModel archive = ArchiveModel(
                    archieveName: archiveNameCtrl.text.toString(),
                  );

                  //Validator
                  if (archive.archieveName.isNotEmpty) {
                    archiveService.addArchive(archive).then((isError) {
                      setState(() => isLoading = false);
                      if (isError) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                FailedDialog(text: "Create archive failed"));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SuccessDialog(text: "Create archive success"));

                        archiveNameCtrl.clear();
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text:
                                "Create archive failed, field can't be empty"));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(successbg),
                ),
                child: const Text('Done'),
              ))
        ],
      ),
    );
  }
}

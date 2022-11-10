import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/DB/Services/ArchieveServices.dart';
import 'package:mi_fik/Others/FailedDialog.dart';
import 'package:mi_fik/Others/SuccessDialog.dart';
import 'package:mi_fik/main.dart';

class AddTaskwArchive extends StatefulWidget {
  AddTaskwArchive({Key key, this.text}) : super(key: key);
  String text;

  @override
  _AddTaskwArchive createState() => _AddTaskwArchive();
}

class _AddTaskwArchive extends State<AddTaskwArchive> {
  ArchieveService apiService;

  //Initial variable
  final archiveNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ArchieveService();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool _isLoading = false;

    return SpeedDial(
        activeIcon: Icons.close,
        icon: Icons.add,
        iconTheme: IconThemeData(color: whitebg),
        backgroundColor: primaryColor,
        overlayColor: primaryColor,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.post_add_outlined),
            label: 'New Task',
            backgroundColor: primaryColor,
            foregroundColor: whitebg,
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.folder),
            label: 'New Folder',
            backgroundColor: primaryColor,
            foregroundColor: whitebg,
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: roundedLG, topRight: roundedLG)),
                barrierColor: primaryColor.withOpacity(0.5),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: 250,
                    width: fullWidth,
                    padding: EdgeInsets.only(
                        top: paddingMD,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                        color: whitebg,
                        borderRadius: BorderRadius.only(
                            topLeft: roundedLG, topRight: roundedLG)),
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
                              archiveNameCtrl.clear();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text("New Archive",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: textLG)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: paddingXSM),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: archiveNameCtrl,
                            maxLength: 75,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFFB8C00)),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ),
                        Container(
                            // transform: Matrix4.translationValues(
                            //     0.0, fullHeight * 0.94, 0.0),
                            width: fullWidth,
                            height: btnHeightMD,
                            child: ElevatedButton(
                              onPressed: () async {
                                //Mapping.
                                ArchieveModel archive = ArchieveModel(
                                  archieveName: archiveNameCtrl.text.toString(),
                                );

                                //Validator
                                if (archive.archieveName.isNotEmpty) {
                                  apiService
                                      .addArchive(archive)
                                      .then((isError) {
                                    setState(() => _isLoading = false);
                                    if (isError) {
                                      Navigator.pop(context);
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FailedDialog(
                                                  text:
                                                      "Create archive failed"));
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SuccessDialog(
                                                  text:
                                                      "Create archive success"));

                                      archiveNameCtrl.clear();
                                    }
                                  });
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text:
                                                  "Create archive failed, field can't be empty"));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        primaryColor),
                              ),
                              child: const Text('Done'),
                            ))
                      ],
                    ),
                  );
                },
              );
            },
          )
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/DB/Services/ArchieveServices.dart';
import 'package:mi_fik/Others/FailedDialog.dart';
import 'package:mi_fik/Others/SuccessDialog.dart';
import 'package:mi_fik/main.dart';

class EditArchive extends StatefulWidget {
  EditArchive({Key key, this.id, this.archiveName}) : super(key: key);
  String id;
  String archiveName;

  @override
  _EditArchive createState() => _EditArchive();
}

class _EditArchive extends State<EditArchive> {
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
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool _isLoading = false;

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
                        archiveNameCtrl.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text("Edit Archive",
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
                      autofocus: true,
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
                  SizedBox(
                      // transform: Matrix4.translationValues(
                      //     0.0, fullHeight * 0.94, 0.0),
                      width: fullWidth,
                      height: btnHeightMD,
                      child: ElevatedButton(
                        onPressed: () async {
                          //Mapping.
                          ArchieveModel archive = ArchieveModel(
                              archieveName: archiveNameCtrl.text.toString(),
                              idUser: passIdUser.toString());

                          //Validator
                          if (archive.archieveName.isNotEmpty) {
                            apiService
                                .editArchive(archive, widget.id)
                                .then((isError) {
                              setState(() => _isLoading = false);
                              if (isError) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        FailedDialog(
                                            text: "Edit archive failed"));
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SuccessDialog(
                                            text: "Edit archive success"));

                                archiveNameCtrl.clear();
                                selectedIndex = 0;
                                selectedArchiveId = null;
                                selectedArchiveName = null;

                                //For now. need to be fixed soon!!!
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NavBar()),
                                );
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
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(primaryColor),
                        ),
                        child: const Text('Done'),
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

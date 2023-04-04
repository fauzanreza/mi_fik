import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Models/Archive/Archive.dart';
import 'package:mi_fik/Modules/Services/ArchieveServices.dart';
import 'package:mi_fik/Components/FailedDialog.dart';
import 'package:mi_fik/Components/SuccessDialog.dart';
import 'package:mi_fik/main.dart';

class DeleteArchive extends StatefulWidget {
  DeleteArchive({Key key, this.id}) : super(key: key);
  String id;

  @override
  _DeleteArchive createState() => _DeleteArchive();
}

class _DeleteArchive extends State<DeleteArchive> {
  ArchieveService apiService;

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
                                            Colors.red.withOpacity(0.8),
                                        padding:
                                            EdgeInsets.all(paddingMD * 0.8)),
                                    onPressed: () async {
                                      //Mapping.
                                      ArchiveModel archive = ArchiveModel(
                                          idUser: passIdUser.toString());

                                      apiService
                                          .deleteArchive(archive, widget.id)
                                          .then((isError) {
                                        setState(() => _isLoading = false);
                                        if (isError) {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  FailedDialog(
                                                      text:
                                                          "Delete archive failed"));
                                        } else {
                                          selectedIndex = 0;
                                          selectedArchiveId = null;
                                          selectedArchiveName = null;

                                          //For now. need to be fixed soon!!!
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NavBar()),
                                          );

                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SuccessDialog(
                                                      text:
                                                          "Delete archive success"));
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

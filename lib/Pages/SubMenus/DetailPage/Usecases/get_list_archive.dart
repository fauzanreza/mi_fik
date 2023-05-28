import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ListArchive extends StatefulWidget {
  ListArchive({Key key, this.archieves, this.passSlug}) : super(key: key);
  var archieves;
  String passSlug;

  @override
  _ListArchive createState() => _ListArchive();
}

class _ListArchive extends State<ListArchive> {
  ArchiveCommandsService apiCommand;

  @override
  void initState() {
    super.initState();
    apiCommand = ArchiveCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    int i = -1;
    bool isLoading;

    bool reverseBool(bool val) {
      if (val) {
        return false;
      } else {
        return true;
      }
    }

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              height: fullWidth * 1,
              width: fullWidth,
              padding: EdgeInsets.all(paddingMD),
              decoration: BoxDecoration(
                  color: whitebg, borderRadius: BorderRadius.all(roundedMd)),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.archieves.length,
                  itemBuilder: (context, index) {
                    i++;
                    return InkWell(
                        onTap: () {
                          setState(() {
                            int idx = listArchiveCheck.indexWhere((e) =>
                                e['slug_name'] == widget.archieves[index].slug);
                            listArchiveCheck[idx]["check"] = getIntByBool(
                                reverseBool(getBoolByInt(
                                    listArchiveCheck[i]["check"])));
                          });
                        },
                        child: Container(
                            width: fullWidth,
                            margin: EdgeInsets.symmetric(vertical: marginHZ),
                            padding: EdgeInsets.all(marginMT),
                            decoration: BoxDecoration(
                              color: whitebg,
                              borderRadius: BorderRadius.circular(roundedMd2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 128, 128, 128)
                                          .withOpacity(0.3),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(
                                    5.0,
                                    5.0,
                                  ),
                                )
                              ],
                            ),
                            child: Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: fullWidth * 0.5,
                                        child: Text(
                                            widget.archieves[index].archiveName
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: blackbg,
                                                fontSize: textSM,
                                                fontWeight: FontWeight.w500))),
                                    SizedBox(height: paddingXSM),
                                    Text(
                                        getTotalArchive(
                                            widget.archieves[index].totalEvent,
                                            widget.archieves[index].totalTask),
                                        style: TextStyle(
                                          color: blackbg,
                                          fontSize: textXSM,
                                        )),
                                  ]),
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.all(primaryColor),
                                value:
                                    getBoolByInt(listArchiveCheck[i]["check"]),
                                onChanged: (bool value) {
                                  setState(() {
                                    int idx = listArchiveCheck.indexWhere((e) =>
                                        e['slug_name'] ==
                                        widget.archieves[index].slug);
                                    listArchiveCheck[idx]["check"] =
                                        getIntByBool(value);
                                  });
                                },
                              )
                            ])));
                  })),
          const SizedBox(height: 20),
          Container(
              width: fullWidth,
              height: btnHeightMD,
              margin: EdgeInsets.only(
                  left: marginMT, right: marginMT, bottom: btnHeightMD),
              child: ElevatedButton(
                onPressed: () async {
                  MultiRelationArchiveModel data = MultiRelationArchiveModel(
                      list: validateNullJSON((listArchiveCheck)));

                  //Validator
                  if (data.list != null) {
                    apiCommand
                        .multiActionArchiveRel(data, widget.passSlug)
                        .then((response) {
                      setState(() => isLoading = false);
                      var status = response[0]['message'];
                      var body = response[0]['body'];

                      if (status == "success") {
                        Get.back();
                        showDialog<String>(
                            barrierDismissible: true,
                            barrierColor: primaryColor.withOpacity(0.5),
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                elevation: 0, //Remove shadow.
                                backgroundColor: Colors.transparent,
                                content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: fullWidth * 0.45,
                                        padding:
                                            EdgeInsets.all(fullWidth * 0.1),
                                        margin:
                                            EdgeInsets.only(bottom: marginMT),
                                        decoration: BoxDecoration(
                                          color: whitebg,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                              'assets/icon/checklist.png'),
                                        ),
                                      ),
                                      Text("Post Saved",
                                          style: TextStyle(
                                              color: whitebg,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textLG))
                                    ])));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => FailedDialog(
                                text: body, type: "editarchiverel"));
                      }
                    });
                  } else {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => FailedDialog(
                            text: "Nothing has changed", type: "editacc"));
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(roundedLG2),
                  )),
                  backgroundColor: MaterialStatePropertyAll<Color>(successbg),
                ),
                child: Text('Save',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: textMD)),
              ))
        ]));
  }
}

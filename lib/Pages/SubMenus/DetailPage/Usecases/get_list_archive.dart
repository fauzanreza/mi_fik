import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class ListArchive extends StatefulWidget {
  const ListArchive({Key key, this.archieves, this.passSlug, this.type})
      : super(key: key);
  final List archieves;
  final String passSlug;
  final String type;

  @override
  StateListArchive createState() => StateListArchive();
}

class StateListArchive extends State<ListArchive> {
  ArchiveCommandsService apiCommand;
  int start = 0;

  @override
  void initState() {
    super.initState();
    apiCommand = ArchiveCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    int i = start;

    bool reverseBool(bool val) {
      if (val) {
        return false;
      } else {
        return true;
      }
    }

    return GestureDetector(
        onTap: () {
          Get.back();
        },
        child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            content:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  height: fullWidth * 1,
                  width: fullWidth,
                  padding: EdgeInsets.all(spaceLG),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundedSM))),
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: spaceSM / 2),
                      itemCount: widget.archieves.length,
                      itemBuilder: (context, index) {
                        if (i < widget.archieves.length - 1) {
                          i++;
                        }

                        return InkWell(
                            onTap: () {
                              setState(() {
                                int idx = listArchiveCheck.indexWhere((e) =>
                                    e['slug_name'] ==
                                    widget.archieves[index].slug);
                                listArchiveCheck[idx]["check"] = getIntByBool(
                                    reverseBool(getBoolByInt(
                                        listArchiveCheck[index]["check"])));
                              });
                            },
                            child: Container(
                                width: fullWidth,
                                margin:
                                    EdgeInsets.symmetric(vertical: spaceMini),
                                padding: EdgeInsets.all(spaceMD),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(roundedSM),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 128, 128, 128)
                                          .withOpacity(0.35),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: fullWidth * 0.5,
                                            child: Text(
                                                widget.archieves[index]
                                                    .archiveName
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: darkColor,
                                                    fontSize: textSM,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        SizedBox(height: spaceSM),
                                        Text(
                                            getTotalArchive(
                                                widget.archieves[index]
                                                    .totalEvent,
                                                widget.archieves[index]
                                                    .totalTask),
                                            style: TextStyle(
                                              color: darkColor,
                                              fontSize: textXSM,
                                            )),
                                      ]),
                                  Checkbox(
                                    checkColor: whiteColor,
                                    fillColor:
                                        MaterialStateProperty.all(primaryColor),
                                    value: getBoolByInt(
                                        listArchiveCheck[index]["check"]),
                                    onChanged: (bool value) {
                                      setState(() {
                                        int idx = listArchiveCheck.indexWhere(
                                            (e) =>
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
                      left: spaceMD, right: spaceMD, bottom: btnHeightMD),
                  child: ElevatedButton(
                    onPressed: () async {
                      MultiRelationArchiveModel data =
                          MultiRelationArchiveModel(
                              list: validateNullJSON((listArchiveCheck)));

                      //Validator
                      if (data.list != null) {
                        apiCommand
                            .multiActionArchiveRel(
                                data, widget.passSlug, widget.type)
                            .then((response) {
                          setState(() => {});
                          var status = response[0]['message'];
                          var body = response[0]['body'];

                          if (status == "success") {
                            if (widget.type == "Event") {
                              Get.to(
                                  () => DetailPage(passSlug: widget.passSlug),
                                  preventDuplicates: false);
                              Get.back();
                            } else {
                              Get.toNamed(CollectionRoute.bar,
                                  preventDuplicates: false);
                            }

                            showDialog<String>(
                                barrierDismissible: true,
                                barrierColor: primaryColor.withOpacity(0.5),
                                context: context,
                                builder: (BuildContext context) =>
                                    GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: SuccessDialogCustom(
                                            text:
                                                "${ucFirst(widget.type)} Saved"
                                                    .tr)));
                          } else {
                            Get.dialog(FailedDialog(
                                text: body, type: "editarchiverel"));
                          }
                        });
                      } else {
                        Get.dialog(FailedDialog(
                            text: "Nothing has changed".tr, type: "editacc"));
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(roundedSM),
                      )),
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(successBG),
                    ),
                    child: Text('Save'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: textXMD)),
                  ))
            ])));
  }
}

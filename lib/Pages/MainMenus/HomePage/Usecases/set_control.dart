import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetControl extends StatefulWidget {
  const SetControl({Key key, this.titleCtrl}) : super(key: key);
  final TextEditingController titleCtrl;

  @override
  _SetControl createState() => _SetControl();
}

class _SetControl extends State<SetControl> {
  Future<Role> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('role_list_key');

    if (roles != null) {
      return Role(role: roles);
    } else {
      Get.offAll(() => const LoginPage());
      Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
          backgroundColor: whitebg);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (searchingContent != null) {
      widget.titleCtrl.text = searchingContent;
    }
    return FutureBuilder<Role>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var roles = jsonDecode(snapshot.data.role);

            double fullHeight = MediaQuery.of(context).size.height;
            double fullWidth = MediaQuery.of(context).size.width;

            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
              ),
              onPressed: () {
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
                        height: fullHeight * 0.8,
                        padding: MediaQuery.of(context).viewInsets,
                        child: Stack(children: [
                          ListView(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.close, size: iconMD),
                                  tooltip: 'Back',
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: paddingMD),
                                  child: getSubTitleMedium("Search by title".tr,
                                      primaryColor, TextAlign.start)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: fullWidth * 0.8,
                                    margin: EdgeInsets.symmetric(
                                        vertical: paddingXSM),
                                    padding: EdgeInsets.only(left: paddingMD),
                                    child: TextField(
                                      cursorColor: whitebg,
                                      maxLength: 75,
                                      controller: widget.titleCtrl,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          hintText: 'ex : webinar',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 1, color: primaryColor),
                                          ),
                                          fillColor: whitebg,
                                          filled: true),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                      margin: EdgeInsets.only(
                                          right: marginMD, bottom: marginMD),
                                      child: Ink(
                                        height: 40,
                                        width: 40,
                                        decoration: ShapeDecoration(
                                          color: dangerColor,
                                          shape: const CircleBorder(),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.close, size: iconMD),
                                          color: whitebg,
                                          onPressed: () {
                                            searchingContent = null;
                                            Get.offAll(() => const BottomBar());
                                          },
                                        ),
                                      )),
                                ],
                              ),
                              Divider(
                                  thickness: 1,
                                  indent: paddingMD,
                                  endIndent: paddingMD),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: paddingMD, top: paddingSM),
                                  child: getSubTitleMedium("Filter by date".tr,
                                      primaryColor, TextAlign.start)),
                              Container(
                                padding: EdgeInsets.only(left: paddingSM),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    getDatePicker(filterDateStart, () {
                                      final now = DateTime.now();

                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(
                                              now.year, now.month, now.day),
                                          maxTime: DateTime(
                                              now.year + 1, now.month, now.day),
                                          onConfirm: (date) {
                                        setState(() {
                                          filterDateStart = date;
                                        });
                                      },
                                          currentTime: now,
                                          locale: LocaleType.en);
                                    }, "Start", "date"),
                                    getDatePicker(filterDateEnd, () {
                                      final now = DateTime.now();

                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime:
                                              getMinEndTime(filterDateStart),
                                          maxTime: DateTime(
                                              now.year + 1, now.month, now.day),
                                          onConfirm: (date) {
                                        setState(() {
                                          filterDateEnd = date;
                                        });
                                      },
                                          currentTime:
                                              getMinEndTime(filterDateStart),
                                          locale: LocaleType.en);
                                    }, "End", "date"),
                                    const Spacer(),
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: marginMD, bottom: marginMD),
                                        child: Ink(
                                          height: 40,
                                          width: 40,
                                          decoration: ShapeDecoration(
                                            color: dangerColor,
                                            shape: const CircleBorder(),
                                          ),
                                          child: IconButton(
                                            icon:
                                                Icon(Icons.close, size: iconMD),
                                            color: whitebg,
                                            onPressed: () {
                                              filterDateStart = null;
                                              filterDateEnd = null;
                                              Get.offAll(
                                                  () => const BottomBar());
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Divider(
                                  thickness: 1,
                                  indent: paddingMD,
                                  endIndent: paddingMD),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: paddingMD, top: paddingSM),
                                  child: getSubTitleMedium("Sorting".tr,
                                      primaryColor, TextAlign.start)),
                              Container(
                                padding: EdgeInsets.only(left: paddingMD),
                                child: DropdownButton<String>(
                                  value: sortingHomepageContent,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: iconSM.toInt(),
                                  style: TextStyle(
                                      color: blackbg, fontSize: textMD),
                                  onChanged: (String value) {
                                    sortingHomepageContent = value;
                                  },
                                  items: sortingOpt
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Divider(
                                  thickness: 1,
                                  indent: paddingMD,
                                  endIndent: paddingMD),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: paddingSM),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Filter by tag".tr,
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: textMD)),
                                    const Spacer(),
                                    outlinedButtonCustom(() {
                                      selectedTagFilterContent.clear();
                                      Get.offAll(() => const BottomBar());
                                    }, "Clear All".tr, Icons.delete)
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: paddingMD),
                                  child: Wrap(
                                      runSpacing: -5,
                                      spacing: 5,
                                      children: roles.map<Widget>((tag) {
                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              selectedTagFilterContent.add({
                                                "slug_name": tag['slug_name'],
                                                "tag_name": tag['tag_name']
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.circle,
                                            size: textSM,
                                            color: Colors.green,
                                          ),
                                          label: Text(tag['tag_name'],
                                              style:
                                                  TextStyle(fontSize: textXSM)),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundedLG2),
                                            )),
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    primaryColor),
                                          ),
                                        );
                                      }).toList())),
                              Padding(
                                  padding: EdgeInsets.only(left: paddingSM),
                                  child: TagSelectedArea(
                                      tag: selectedTagFilterContent,
                                      type: "filter")),
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                  margin: EdgeInsets.only(top: paddingXSM),
                                  width: fullWidth,
                                  height: btnHeightMD,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      searchingContent =
                                          widget.titleCtrl.text.trim();
                                      Get.offAll(() => const BottomBar());
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              successbg),
                                    ),
                                    child: Text('Apply Setting'.tr),
                                  )))
                        ]));
                  },
                );
              },
              child: Icon(
                Icons.filter_alt,
                color: whitebg,
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

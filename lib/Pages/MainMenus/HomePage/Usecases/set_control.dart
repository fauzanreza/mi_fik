import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SetControl extends StatefulWidget {
  const SetControl({Key key, this.titleCtrl}) : super(key: key);
  final TextEditingController titleCtrl;

  @override
  StateSetControl createState() => StateSetControl();
}

class StateSetControl extends State<SetControl> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Role>(
        future: getRoleSess(true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var roles = jsonDecode(snapshot.data.role);

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
                          topLeft: Radius.circular(roundedLG),
                          topRight: Radius.circular(roundedLG))),
                  barrierColor: primaryColor.withOpacity(0.5),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    if (searchingContent != null) {
                      widget.titleCtrl.text = searchingContent;
                    }
                    return SheetFilter(title: widget.titleCtrl, roles: roles);
                  },
                );
              },
              child: Icon(
                Icons.filter_alt,
                color: whiteColor,
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

class SheetFilter extends StatefulWidget {
  const SheetFilter({Key key, this.title, this.roles}) : super(key: key);
  final TextEditingController title;
  final List roles;

  @override
  StateSheetFilter createState() => StateSheetFilter();
}

class StateSheetFilter extends State<SheetFilter> {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Container(
        height: fullHeight * 0.8,
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(children: [
          ListView(
            padding: EdgeInsets.only(bottom: spaceJumbo * 3),
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
                  padding: EdgeInsets.only(left: spaceLG),
                  child: getSubTitleMedium(
                      "Search by title".tr, primaryColor, TextAlign.start)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: fullWidth * 0.8,
                    margin: EdgeInsets.symmetric(vertical: spaceSM),
                    padding: EdgeInsets.only(left: spaceLG),
                    child: TextField(
                      cursorColor: whiteColor,
                      maxLength: 75,
                      controller: widget.title,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'ex : webinar',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 1, color: primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 1, color: primaryColor),
                          ),
                          fillColor: whiteColor,
                          filled: true),
                    ),
                  ),
                  const Spacer(),
                  Container(
                      margin:
                          EdgeInsets.only(right: spaceXLG, bottom: spaceXLG),
                      child: Ink(
                        height: 40,
                        width: 40,
                        decoration: ShapeDecoration(
                          color: warningBG,
                          shape: const CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, size: iconMD),
                          color: whiteColor,
                          onPressed: () {
                            searchingContent = "";
                            Get.toNamed(CollectionRoute.bar,
                                preventDuplicates: false);
                          },
                        ),
                      )),
                ],
              ),
              Divider(thickness: 1, indent: spaceLG, endIndent: spaceLG),
              Container(
                  padding: EdgeInsets.only(left: spaceLG, top: spaceXMD),
                  child: getSubTitleMedium(
                      "Filter by date".tr, primaryColor, TextAlign.start)),
              Container(
                padding: EdgeInsets.only(left: spaceXMD),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getDatePicker(filterDateStart, () {
                      final now = DateTime.now();

                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(now.year, now.month, now.day),
                          maxTime: DateTime(now.year + 1, now.month, now.day),
                          onConfirm: (date) {
                        setState(() {
                          filterDateStart = date;
                        });
                      }, currentTime: now, locale: LocaleType.en);
                    }, "Start", "date"),
                    getDatePicker(filterDateEnd, () {
                      final now = DateTime.now();

                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: getMinEndTime(filterDateStart),
                          maxTime: DateTime(now.year + 1, now.month, now.day),
                          onConfirm: (date) {
                        setState(() {
                          filterDateEnd = date;
                        });
                      },
                          currentTime: getMinEndTime(filterDateStart),
                          locale: LocaleType.en);
                    }, "End", "date"),
                    const Spacer(),
                    Container(
                        margin:
                            EdgeInsets.only(right: spaceXLG, bottom: spaceXLG),
                        child: Ink(
                          height: 40,
                          width: 40,
                          decoration: ShapeDecoration(
                            color: warningBG,
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close, size: iconMD),
                            color: whiteColor,
                            onPressed: () {
                              filterDateStart = null;
                              filterDateEnd = null;
                              Get.toNamed(CollectionRoute.bar,
                                  preventDuplicates: false);
                            },
                          ),
                        )),
                  ],
                ),
              ),
              Divider(thickness: 1, indent: spaceLG, endIndent: spaceLG),
              Container(
                  padding: EdgeInsets.only(left: spaceLG, top: spaceXMD),
                  child: getSubTitleMedium(
                      "Sorting".tr, primaryColor, TextAlign.start)),
              Container(
                padding: EdgeInsets.only(left: spaceLG),
                child: DropdownButton<String>(
                  value: sortingHomepageContent,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: iconSM.toInt(),
                  style: TextStyle(color: darkColor, fontSize: textXMD),
                  onChanged: (String value) {
                    sortingHomepageContent = value;
                  },
                  items:
                      sortingOpt.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Divider(thickness: 1, indent: spaceLG, endIndent: spaceLG),
              Container(
                padding: EdgeInsets.symmetric(horizontal: spaceXMD),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Filter by tag".tr,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: textXMD)),
                    const Spacer(),
                    outlinedButtonCustom(() {
                      selectedTagFilterContent.clear();
                      Get.toNamed(CollectionRoute.bar,
                          preventDuplicates: false);
                    }, "Clear All".tr, Icons.delete)
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: spaceLG),
                  child: Wrap(
                      runSpacing: -spaceWrap,
                      spacing: spaceWrap,
                      children: widget.roles.map<Widget>((tag) {
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
                              style: TextStyle(fontSize: textXSM)),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(roundedMD),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(primaryColor),
                          ),
                        );
                      }).toList())),
              Padding(
                  padding: EdgeInsets.only(left: spaceXMD),
                  child: TagSelectedArea(
                      tag: selectedTagFilterContent, type: "filter")),
            ],
          ),
          Positioned(
              bottom: 0,
              child: Container(
                  margin: EdgeInsets.only(top: spaceSM),
                  width: fullWidth,
                  height: btnHeightMD,
                  child: ElevatedButton(
                    onPressed: () {
                      searchingContent = widget.title.text.trim();
                      Get.toNamed(CollectionRoute.bar,
                          preventDuplicates: false);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(successBG),
                    ),
                    child: Text('Apply Setting'.tr),
                  )))
        ]));
  }
}

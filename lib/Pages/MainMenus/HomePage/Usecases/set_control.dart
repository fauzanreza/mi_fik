import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Forms/date_picker.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetControl extends StatefulWidget {
  const SetControl(
      {Key key,
      this.titleCtrl,
      this.setDateStartCtrl,
      this.setDateEndCtrl,
      this.dateStart,
      this.dateEnd})
      : super(key: key);
  final TextEditingController titleCtrl;
  final Function(DateTime) setDateStartCtrl;
  final Function(DateTime) setDateEndCtrl;
  final DateTime dateStart;
  final DateTime dateEnd;

  @override
  _SetControl createState() => _SetControl();
}

class _SetControl extends State<SetControl> {
  Future<Role> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('role_list_key');
    return Role(role: roles);
  }

  @override
  Widget build(BuildContext context) {
    if (searchingContent != null) {
      widget.titleCtrl.text = searchingContent;
    }
    return FutureBuilder<Role>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                      child: ListView(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Back',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: paddingMD),
                              child: getSubTitleMedium(
                                  "Search by title", primaryColor)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: fullWidth * 0.8,
                                margin:
                                    EdgeInsets.symmetric(vertical: paddingXSM),
                                padding: EdgeInsets.only(left: paddingMD),
                                child: TextField(
                                  cursorColor: whitebg,
                                  maxLength: 75,
                                  controller: widget.titleCtrl,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      hintText: 'ex : webinar',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1, color: primaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                      icon: Icon(Icons.close, size: iconMD - 5),
                                      color: whitebg,
                                      onPressed: () {
                                        searchingContent = null;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomBar()),
                                        );
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
                              child: getSubTitleMedium(
                                  "Filter by date", primaryColor)),
                          Container(
                            padding: EdgeInsets.only(left: paddingSM),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getDatePicker(widget.dateStart, () {
                                  final now = DateTime.now();

                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(
                                          now.year, now.month, now.day),
                                      maxTime: DateTime(
                                          now.year + 1, now.month, now.day),
                                      onConfirm: (date) =>
                                          widget.setDateStartCtrl(date),
                                      currentTime: now,
                                      locale: LocaleType.en);
                                }, "Start", "date"),
                                getDatePicker(widget.dateEnd, () {
                                  final now = DateTime.now();

                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(
                                          now.year, now.month, now.day),
                                      maxTime: DateTime(
                                          now.year + 1, now.month, now.day),
                                      onConfirm: (date) =>
                                          widget.setDateEndCtrl(date),
                                      currentTime: now,
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
                                            Icon(Icons.close, size: iconMD - 5),
                                        color: whitebg,
                                        onPressed: () {
                                          filterDateStart = null;
                                          filterDateEnd = null;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomBar()),
                                          );
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
                              child:
                                  getSubTitleMedium("Sorting", primaryColor)),
                          Container(
                            padding: EdgeInsets.only(left: paddingMD),
                            child: DropdownButton<String>(
                              value: sortingHomepageContent,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: iconSM.toInt(),
                              style:
                                  TextStyle(color: blackbg, fontSize: textMD),
                              onChanged: (String value) {
                                sortingHomepageContent = value;
                              },
                              items: sortingOpt.map<DropdownMenuItem<String>>(
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
                                Text("Filter by tag",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textMD)),
                                const Spacer(),
                                outlinedButtonCustom(() {
                                  selectedTagFilterContent.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomBar()),
                                  );
                                }, "Clear All", Icons.delete)
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
                                          style: TextStyle(fontSize: textXSM)),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(roundedLG2),
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
                          Container(
                              margin: EdgeInsets.only(top: paddingXSM),
                              width: fullWidth,
                              height: btnHeightMD,
                              child: ElevatedButton(
                                onPressed: () {
                                  searchingContent =
                                      widget.titleCtrl.text.trim();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomBar()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          successbg),
                                ),
                                child: const Text('Apply Setting'),
                              ))
                        ],
                      ),
                    );
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

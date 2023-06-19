import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Forms/tag_picker.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseTag extends StatefulWidget {
  const ChooseTag({Key key}) : super(key: key);

  @override
  StateChooseTag createState() => StateChooseTag();
}

class StateChooseTag extends State<ChooseTag> {
  int pageTag = 1;

  Future<Role> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('role_list_key');
    return Role(role: roles);
  }

  void updateTags() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    Widget getControlButton(type) {
      if (type == "more") {
        return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 15),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  pageTag++;
                });
              },
              icon: Icon(Icons.navigate_next, color: primaryColor),
              label: Text(
                "More".tr,
                style: TextStyle(color: primaryColor),
              ),
            ));
      } else if (type == "previous" && pageTag > 1) {
        return Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  pageTag--;
                });
              },
              icon: Icon(Icons.navigate_before, color: primaryColor),
              label: Text(
                "Previous".tr,
                style: TextStyle(color: primaryColor),
              ),
            ));
      } else {
        return const SizedBox();
      }
    }

    return FutureBuilder<Role>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var roles = jsonDecode(snapshot.data.role);
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    runSpacing: -5,
                    spacing: 5,
                    children: roles.map<Widget>((tag) {
                      //Check if tag already selected
                      var contain = selectedTag.where(
                          (item) => item['slug_name'] == tag['slug_name']);
                      if (contain.isEmpty || selectedTag.isEmpty) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedTag.add({
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
                              borderRadius: BorderRadius.circular(roundedLG2),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(primaryColor),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),
                  Row(
                    children: [
                      getControlButton("previous".tr),
                      const Spacer(),
                      getControlButton("more".tr),
                    ],
                  ),
                  TagSelectedArea(
                      tag: selectedTag, type: "tag", action: updateTags)
                ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

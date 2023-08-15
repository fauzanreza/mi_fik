import 'dart:convert';

import 'package:flutter/material.dart';
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
                    runSpacing: -spaceWrap,
                    spacing: spaceWrap,
                    children: roles.map<Widget>((tag) {
                      var contain = selectedTag.where(
                          (item) => item['slug_name'] == tag['slug_name']);
                      if (contain.isEmpty || selectedTag.isEmpty) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTag.add({
                                "slug_name": tag['slug_name'],
                                "tag_name": tag['tag_name']
                              });
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(roundedMD),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(primaryColor),
                          ),
                          child: Text(tag['tag_name'],
                              style: TextStyle(fontSize: textXSM)),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),
                  TagSelectedArea(
                      tag: selectedTag, type: "tag", action: updateTags)
                ]);
          } else {
            return Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
        });
  }
}

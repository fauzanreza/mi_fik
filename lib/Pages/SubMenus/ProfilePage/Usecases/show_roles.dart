import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowRole extends StatelessWidget {
  const ShowRole({Key key}) : super(key: key);

  Future<Role> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('role_list_key');
    return Role(role: roles);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Role>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var roles = jsonDecode(snapshot.data.role);

            return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFFe8e8e8), width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(
                        vertical: paddingXSM / 2, horizontal: paddingSM),
                    childrenPadding: EdgeInsets.only(
                        left: paddingSM, bottom: paddingSM, right: paddingSM),
                    initiallyExpanded: false,
                    iconColor: primaryColor,
                    textColor: blackbg,
                    leading: const Icon(Icons.tag),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    title: Text(ucFirst("My Roles"),
                        style: TextStyle(fontSize: textMD - 1)),
                    children: [
                      Wrap(
                          runSpacing: -5,
                          spacing: 5,
                          children: roles.map<Widget>((tag) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                // Respond to button press
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
                          }).toList()),
                      const Divider(thickness: 1.5)
                    ]));
          } else {
            return const SizedBox();
          }
        });
  }
}

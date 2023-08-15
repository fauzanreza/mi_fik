import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Components/get_tag_bycat.dart';

class GetAllTagCategory extends StatefulWidget {
  const GetAllTagCategory({Key key, this.isLogged}) : super(key: key);
  final bool isLogged;

  @override
  StateGetAllTagCategory createState() => StateGetAllTagCategory();
}

class StateGetAllTagCategory extends State<GetAllTagCategory> {
  TagQueriesService apiQuery;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    apiQuery = TagQueriesService();
    box = GetStorage();
  }

  Widget getElement(contents, bool isModel) {
    String dctName = "";
    String slug = "";

    return ListView.builder(
        itemCount: contents.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          if (isModel) {
            dctName = contents[index].dctName;
            slug = contents[index].slug;
          } else {
            dctName = contents[index]['dct_name'];
            slug = contents[index]['slug_name'];
          }

          if (Get.currentRoute != "/role" || slug != "general-role") {
            Widget getItem() {
              return Container(
                padding: EdgeInsets.all(spaceSM),
                margin: EdgeInsets.only(bottom: spaceSM),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(ucAll(dctName),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: darkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: textXMD)),
                    const Divider(
                      thickness: 1,
                    ),
                    GetAllTagByCategory(slug: slug, isLogged: widget.isLogged)
                  ],
                ),
              );
            }

            if (index == 0) {
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(
                          spaceMD, spaceMD, spaceMD, spaceLG),
                      margin: EdgeInsets.only(bottom: spaceSM),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getTitleLarge("Choose Your Role".tr, primaryColor),
                          SizedBox(height: spaceSM),
                          Text(
                              "Role system will shows your preferable information in your timeline, and you can save your information based on your roles to archive. Please choose your roles based on your academic situation right now.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: darkColor, fontSize: textMD)),
                        ],
                      )),
                  getItem()
                ],
              );
            } else {
              return getItem();
            }
          } else {
            return const SizedBox();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    List<TagCategoryModel> contents;
    if (!box.hasData("tag-cat")) {
      return SafeArea(
        maintainBottomViewPadding: false,
        child: FutureBuilder(
          future: apiQuery.getAllTagCategory(),
          builder: (BuildContext context,
              AsyncSnapshot<List<TagCategoryModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              contents = snapshot.data;
              var lst = [];
              for (var element in contents) {
                if (element.slug != "general-role" ||
                    Get.currentRoute != "/role") {
                  lst.add(
                      {"slug_name": element.slug, "dct_name": element.dctName});
                }
              }

              box.write("tag-cat", jsonEncode(lst));
              return _buildListView(contents);
            } else {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
          },
        ),
      );
    } else {
      return getElement(jsonDecode(box.read("tag-cat")), false);
    }
  }

  Widget _buildListView(List<TagCategoryModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return getElement(contents, true);
  }
}

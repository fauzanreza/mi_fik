import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAllTagByCategory extends StatefulWidget {
  const GetAllTagByCategory({Key key, this.slug}) : super(key: key);
  final String slug;

  @override
  StateGetAllTagByCategory createState() => StateGetAllTagByCategory();
}

class StateGetAllTagByCategory extends State<GetAllTagByCategory> {
  TagQueriesService apiQuery;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    apiQuery = TagQueriesService();
    box = GetStorage();
  }

  Widget getElement(contents, bool isModel) {
    if (contents != null) {
      String tagName = "";
      String slug = "";

      return Wrap(
          runSpacing: -5,
          spacing: 5,
          children: contents.map<Widget>((e) {
            if (isModel) {
              tagName = e.tagName;
              slug = e.slug;
            } else {
              tagName = e['tag_name'];
              slug = e['slug_name'];
            }

            var contain =
                selectedRole.where((item) => item['slug_name'] == slug);
            if (contain.isEmpty || selectedRole.isEmpty) {
              return ElevatedButton(
                onPressed: () {
                  String tagNameState = "";
                  String slugState = "";
                  if (isModel) {
                    tagNameState = e.tagName;
                    slugState = e.slug;
                  } else {
                    tagNameState = e['tag_name'];
                    slugState = e['slug_name'];
                  }
                  setState(() {
                    selectedRole.add(
                        {"slug_name": slugState, "tag_name": tagNameState});
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(roundedSM),
                  )),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(primaryColor),
                ),
                child: Text(tagName, style: TextStyle(fontSize: textXSM)),
              );
            } else {
              return const SizedBox();
            }
          }).toList());
    } else {
      return Center(child: Text("No role available".tr));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TagAllModel> contents;

    if (box.read("tag-bycat-${widget.slug}") == null) {
      return SafeArea(
        maintainBottomViewPadding: false,
        child: FutureBuilder(
          future: apiQuery.getAllTagByCategory(widget.slug),
          builder: (BuildContext context,
              AsyncSnapshot<List<TagAllModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                contents = snapshot.data;
                var lst = [];
                for (var element in contents) {
                  lst.add(
                      {"slug_name": element.slug, "tag_name": element.tagName});
                }
                box.write("tag-bycat-${widget.slug}", jsonEncode(lst));
                return _buildListView(contents);
              } else {
                return Center(child: Text("No role available".tr));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    } else {
      return getElement(
          jsonDecode(box.read("tag-bycat-${widget.slug}")), false);
    }
  }

  Widget _buildListView(List<TagAllModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;
    return getElement(contents, true);
  }
}

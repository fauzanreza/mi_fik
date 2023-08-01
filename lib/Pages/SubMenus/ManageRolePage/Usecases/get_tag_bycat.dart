import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAllTagByCategory extends StatefulWidget {
  const GetAllTagByCategory({Key key, this.slug, this.isLogged})
      : super(key: key);
  final String slug;
  final bool isLogged;

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

  Widget getElement(contents, bool isModel, mytag) {
    if (contents != null) {
      String tagName = "";
      String slug = "";
      dynamic assigned = [];
      int i = 0;

      return Column(children: [
        Wrap(
            runSpacing: -spaceWrap,
            spacing: spaceWrap,
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

              if (mytag != null) {
                assigned = mytag.where((item) => item['slug_name'] == slug);
              }
              if ((contain.isEmpty || selectedRole.isEmpty) &&
                  assigned.isEmpty) {
                i++;
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
            }).toList()),
        i == 0
            ? Center(
                child: Text("You have picked all role".tr,
                    style: TextStyle(fontSize: textSM)))
            : const SizedBox()
      ]);
    } else {
      return Center(
          child:
              Text("No role available".tr, style: TextStyle(fontSize: textSM)));
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
              return const Center(
                child: Text("Something wrong"),
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

                if (widget.isLogged) {
                  return FutureBuilder<Role>(
                      future: getRoleSess(widget.isLogged),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          var roles = jsonDecode(snapshot.data.role);

                          return _buildListView(contents, roles);
                        } else {
                          return const SizedBox();
                        }
                      });
                } else {
                  return _buildListView(contents, null);
                }
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
      return FutureBuilder<Role>(
          future: getRoleSess(false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              var roles = jsonDecode(snapshot.data.role);

              return getElement(
                  jsonDecode(box.read("tag-bycat-${widget.slug}")),
                  false,
                  roles);
            } else if (snapshot.connectionState == ConnectionState.none) {
              return getElement(
                  jsonDecode(box.read("tag-bycat-${widget.slug}")),
                  false,
                  null);
            } else {
              return getElement(
                  jsonDecode(box.read("tag-bycat-${widget.slug}")),
                  false,
                  null);
            }
          });
    }
  }

  Widget _buildListView(List<TagAllModel> contents, roles) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;
    return getElement(contents, true, roles);
  }
}

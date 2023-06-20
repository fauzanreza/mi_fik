import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_bycat.dart';

class GetAllTagCategory extends StatefulWidget {
  const GetAllTagCategory({Key key}) : super(key: key);

  @override
  StateGetAllTagCategory createState() => StateGetAllTagCategory();
}

class StateGetAllTagCategory extends State<GetAllTagCategory> {
  TagQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = TagQueriesService();
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

          return Container(
            padding: EdgeInsets.all(paddingXSM),
            margin: EdgeInsets.only(bottom: paddingXSM),
            decoration: BoxDecoration(
                color: whitebg,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(dctName,
                    style: TextStyle(
                        color: blackbg,
                        fontWeight: FontWeight.bold,
                        fontSize: textMD)),
                const Divider(
                  thickness: 1,
                ),
                GetAllTagByCategory(slug: slug)
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    List<TagCategoryModel> contents;

    if (box.read("tag-cat") == null) {
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
                lst.add(
                    {"slug_name": element.slug, "dct_name": element.dctName});
              }

              box.write("tag-cat", jsonEncode(lst));
              return _buildListView(contents);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
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

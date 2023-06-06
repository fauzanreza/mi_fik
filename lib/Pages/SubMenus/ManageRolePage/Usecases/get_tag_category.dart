import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ManageRolePage/Usecases/get_tag_bycat.dart';

class GetAllTagCategory extends StatefulWidget {
  const GetAllTagCategory({Key key}) : super(key: key);

  @override
  _GetAllTagCategory createState() => _GetAllTagCategory();
}

class _GetAllTagCategory extends State<GetAllTagCategory> {
  TagQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = TagQueriesService();
  }

  @override
  Widget build(BuildContext context) {
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
            List<TagCategoryModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<TagCategoryModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
        itemCount: contents.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: whitebg,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(contents[index].dctName,
                    style: TextStyle(
                        color: blackbg,
                        fontWeight: FontWeight.bold,
                        fontSize: textMD)),
                const Divider(
                  thickness: 1,
                ),
                GetAllTagByCategory(slug: contents[index].slug)
              ],
            ),
          );
        });
  }
}

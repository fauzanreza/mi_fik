import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAllTagByCategory extends StatefulWidget {
  GetAllTagByCategory({Key key, this.slug}) : super(key: key);
  String slug;

  @override
  StateGetAllTagByCategory createState() => StateGetAllTagByCategory();
}

class StateGetAllTagByCategory extends State<GetAllTagByCategory> {
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
        future: apiQuery.getAllTagByCategory(widget.slug),
        builder:
            (BuildContext context, AsyncSnapshot<List<TagAllModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<TagAllModel> contents = snapshot.data;
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

  Widget _buildListView(List<TagAllModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      return Wrap(
          runSpacing: -5,
          spacing: 5,
          children: contents.map<Widget>((e) {
            var contain =
                selectedRole.where((item) => item['slug_name'] == e.slug);
            if (contain.isEmpty || selectedRole.isEmpty) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole
                        .add({"slug_name": e.slug, "tag_name": e.tagName});
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(roundedLG2),
                  )),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(primaryColor),
                ),
                child: Text(e.tagName, style: TextStyle(fontSize: textXSM)),
              );
            } else {
              return const SizedBox();
            }
          }).toList());
    } else {
      return const Center(child: Text("No role available"));
    }
  }
}

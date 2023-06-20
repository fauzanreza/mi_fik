import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/TagApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ShowRole extends StatefulWidget {
  const ShowRole({Key key}) : super(key: key);

  @override
  StateShowRole createState() => StateShowRole();
}

class StateShowRole extends State<ShowRole> {
  TagQueriesService queryService;

  @override
  void initState() {
    super.initState();
    queryService = TagQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: queryService.getMyTag(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MyTagModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<MyTagModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  @override
  Widget _buildListView(List<MyTagModel> contents) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: mainbg, width: 1),
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
            leading: Icon(Icons.tag, size: iconLG),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            title: Text(ucFirst("My Roles".tr),
                style: TextStyle(fontSize: textMD - 1)),
            children: [
              Wrap(
                  runSpacing: -5,
                  spacing: 5,
                  children: contents.map<Widget>((tag) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        // Respond to button press
                      },
                      icon: Icon(
                        Icons.circle,
                        size: textSM,
                        color: Colors.green,
                      ),
                      label: Text(tag.tagName,
                          style: TextStyle(fontSize: textXSM)),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(roundedLG2),
                        )),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(primaryColor),
                      ),
                    );
                  }).toList()),
              const Divider(thickness: 1.5)
            ]));
  }
}

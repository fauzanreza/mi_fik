import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/HelpApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAbout extends StatefulWidget {
  const GetAbout({Key key}) : super(key: key);

  @override
  StateGetAbout createState() => StateGetAbout();
}

class StateGetAbout extends State<GetAbout> {
  HelpQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = HelpQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getAbout(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HelpBodyModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<HelpBodyModel> contents = snapshot.data;
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

  Widget _buildListView(List<HelpBodyModel> contents) {
    return Column(
        children: contents.map(
      (e) {
        return Container(
          padding: EdgeInsets.all(spaceLG),
          margin: EdgeInsets.all(spaceXMD),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: whiteColor),
          child: HtmlWidget(e.helpBody),
        );
      },
    ).toList());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/nodata.dart';

import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/HelpApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetHelpByType extends StatefulWidget {
  const GetHelpByType({Key key, this.passType}) : super(key: key);
  final String passType;

  @override
  StateGetHelpByType createState() => StateGetHelpByType();
}

class StateGetHelpByType extends State<GetHelpByType> {
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
        future: apiQuery.getHelpBody(widget.passType),
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
    // double fullHeight = MediaQuery.of(context).size.height;
    // double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      if (contents.isNotEmpty) {
        return Container(
            padding: EdgeInsets.all(spaceXMD),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: contents.map(
                  (content) {
                    if (content.helpBody != null) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(content.helpCategory,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: textMD,
                                    color: darkColor)),
                            const SizedBox(height: 5),
                            HtmlWidget(content.helpBody),
                            const Divider(thickness: 1.5),
                            const SizedBox(height: 10),
                          ]);
                    } else {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(content.helpCategory,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: textMD,
                                    color: darkColor)),
                            const SizedBox(height: 5),
                            const Text("-"),
                            const Divider(thickness: 1.5),
                            const SizedBox(height: 10),
                          ]);
                    }
                  },
                ).toList()));
      } else {
        return Center(child: getNoDataContainer("Help not found".tr, 120));
      }
    } else {
      return Center(
          child: getMessageImageNoData(
              "assets/icon/badnet.png", "Failed to load data".tr, 200));
    }
  }
}

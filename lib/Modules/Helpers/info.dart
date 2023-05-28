import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_info.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_info.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';

import 'package:mi_fik/Modules/Variables/style.dart';

class GetInfoBox extends StatefulWidget {
  GetInfoBox({Key key, this.page, this.location}) : super(key: key);
  String page;
  String location;

  @override
  _GetInfoBox createState() => _GetInfoBox();
}

class _GetInfoBox extends State<GetInfoBox> {
  InfoQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = InfoQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getInfo(widget.page, widget.location),
        builder: (BuildContext context, AsyncSnapshot<InfoModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            InfoModel contents = snapshot.data;
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

  Widget _buildListView(InfoModel contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    Color getInfoColor(String type) {
      if (type == "tips") {
        return const Color(0xFFc6eff8);
      } else {
        return const Color(0xFFf7bdbd);
      }
    }

    return Container(
      padding: EdgeInsets.all(paddingMD),
      decoration: BoxDecoration(
          color: getInfoColor(contents.infoType),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info,
              color: blackbg,
              size: iconMD,
            ),
            SizedBox(width: paddingXSM / 2),
            Text(ucFirst(contents.infoType), style: TextStyle(color: blackbg))
          ],
        ),
        HtmlWidget(contents.infoBody),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_info.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_info.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetInfoBox extends StatefulWidget {
  const GetInfoBox({Key key, this.page, this.location}) : super(key: key);
  final String page;
  final String location;

  @override
  StateGetInfoBox createState() => StateGetInfoBox();
}

class StateGetInfoBox extends State<GetInfoBox> {
  InfoQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = InfoQueriesService();
  }

  Color getinfoBG(String type) {
    if (type == "tips") {
      return const Color(0xFFc6eff8);
    } else {
      return const Color(0xFFf7bdbd);
    }
  }

  Widget getElement(String infoType, String infoBody) {
    return Container(
      padding: EdgeInsets.all(spaceLG),
      decoration: BoxDecoration(
          color: getinfoBG(infoType),
          borderRadius: BorderRadius.all(Radius.circular(roundedMD))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info,
              color: darkColor,
              size: iconMD,
            ),
            SizedBox(width: spaceSM / 2),
            Text(ucFirst(infoType),
                style: TextStyle(color: darkColor, fontSize: textMD))
          ],
        ),
        SizedBox(height: spaceXMD),
        HtmlWidget(infoBody),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    if (box.read("${widget.page}-${widget.location}-type") != null &&
        box.read("${widget.page}-${widget.location}-body") != null) {
      String infoType = box.read("${widget.page}-${widget.location}-type");
      String infoBody = box.read("${widget.page}-${widget.location}-body");

      return getElement(infoType, infoBody);
    } else {
      return SafeArea(
        maintainBottomViewPadding: false,
        child: FutureBuilder(
          future: apiQuery.getInfo(widget.page, widget.location),
          builder: (BuildContext context, AsyncSnapshot<InfoModel> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something wrong"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              InfoModel contents = snapshot.data;

              box.write(
                  "${widget.page}-${widget.location}-type", contents.infoType);
              box.write(
                  "${widget.page}-${widget.location}-body", contents.infoBody);
              return _buildListView(contents);
            } else {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
          },
        ),
      );
    }
  }

  Widget _buildListView(InfoModel contents) {
    return getElement(contents.infoType, contents.infoBody);
  }
}

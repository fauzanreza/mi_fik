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

  Color getInfoColor(String type) {
    if (type == "tips") {
      return const Color(0xFFc6eff8);
    } else {
      return const Color(0xFFf7bdbd);
    }
  }

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    if (box.read("${widget.page}-${widget.location}-type") != null &&
        box.read("${widget.page}-${widget.location}-body") != null) {
      String infoType = box.read("${widget.page}-${widget.location}-type");
      String infoBody = box.read("${widget.page}-${widget.location}-body");

      return Container(
        padding: EdgeInsets.all(paddingMD),
        decoration: BoxDecoration(
            color: getInfoColor(infoType),
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
              Text(ucFirst(infoType), style: TextStyle(color: blackbg))
            ],
          ),
          SizedBox(height: paddingSM),
          HtmlWidget(infoBody),
        ]),
      );
    } else {
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

              box.write(
                  "${widget.page}-${widget.location}-type", contents.infoType);
              box.write(
                  "${widget.page}-${widget.location}-body", contents.infoBody);
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
  }

  Widget _buildListView(InfoModel contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

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
        SizedBox(height: paddingSM),
        HtmlWidget(contents.infoBody),
      ]),
    );
  }
}

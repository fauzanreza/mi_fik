import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Container/nodata.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/queries.dart';

import 'package:mi_fik/Modules/Variables/style.dart';

class GetMyFAQ extends StatefulWidget {
  const GetMyFAQ({Key key}) : super(key: key);

  @override
  _GetMyFAQ createState() => _GetMyFAQ();
}

class _GetMyFAQ extends State<GetMyFAQ> {
  QuestionQueriesService apiQuery;
  int page = 1;

  @override
  void initState() {
    super.initState();
    apiQuery = QuestionQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getMyFAQ(page),
        builder: (BuildContext context,
            AsyncSnapshot<List<MyQuestionModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<MyQuestionModel> contents = snapshot.data;
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

  Widget _buildListView(List<MyQuestionModel> contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: paddingMD),
          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index) {
            if (contents[index].questionFrom == "me") {
              return Container(
                  width: fullWidth,
                  padding: EdgeInsets.all(paddingXSM),
                  margin: EdgeInsets.only(
                      left: fullWidth * 0.2, right: paddingSM, top: paddingXSM),
                  decoration: const BoxDecoration(
                      color: Color(0xFFE88F34),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Text(contents[index].msgBody,
                      style: TextStyle(color: whitebg)));
            } else {
              return Container(
                  width: fullWidth,
                  padding: EdgeInsets.all(paddingXSM),
                  margin: EdgeInsets.only(
                      right: fullWidth * 0.2, left: paddingSM, top: paddingXSM),
                  decoration: const BoxDecoration(
                      color: Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: paddingXSM),
                            padding: EdgeInsets.all(paddingXSM),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF5E6CB),
                                // border: Border(
                                //     left: BorderSide(color: primaryColor)),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(14),
                                    bottomRight: Radius.circular(14))),
                            child: Text(contents[index].msgBody,
                                style: TextStyle(color: blackbg))),
                        Text(contents[index].msgReply)
                      ]));
            }
          });
    } else {
      return Center(child: getNoDataContainer("Message not found"));
    }
  }
}

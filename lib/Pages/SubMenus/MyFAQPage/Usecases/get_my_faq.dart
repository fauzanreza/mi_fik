import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Container/nodata.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';

import 'package:mi_fik/Modules/Variables/style.dart';

class GetMyFAQ extends StatefulWidget {
  const GetMyFAQ({Key key}) : super(key: key);

  @override
  StateGetMyFAQ createState() => StateGetMyFAQ();
}

class StateGetMyFAQ extends State<GetMyFAQ> {
  QuestionQueriesService apiQuery;
  int page = 1;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    setState(() {});
  }

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
    String dateChipBefore = "";

    Widget getMsgBody(String text) {
      if (text != null) {
        return Container(
            margin: EdgeInsets.only(bottom: paddingXSM),
            padding: EdgeInsets.all(paddingXSM),
            decoration: const BoxDecoration(
                color: Color(0xFFF5E6CB),
                // border: Border(
                //     left: BorderSide(color: primaryColor)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14))),
            child: Text(text, style: TextStyle(color: blackbg)));
      } else {
        return const SizedBox();
      }
    }

    if (contents != null) {
      return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshData,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: paddingLg * 2.25),
              itemCount: contents.length,
              itemBuilder: (BuildContext context, int index) {
                Widget getDateChip() {
                  var dt = contents[index].createdAt;
                  var date = DateTime.parse(dt);

                  String check = ("${date.year}${date.month}${date.day}");
                  if (dateChipBefore != check) {
                    dateChipBefore = check;
                    var dateContext = DateFormat("dd MMM yyyy").format(date);
                    var yesterdayContext = DateFormat("dd MMM yyyy")
                        .format(date.add(const Duration(days: 1)));

                    if (getToday("date") == dateContext) {
                      dateContext = "Today".tr;
                    } else if (getToday("date") == yesterdayContext) {
                      dateContext = "Yesterday".tr;
                    }

                    return Container(
                        margin: EdgeInsets.only(top: paddingSM),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: paddingXSM - 2),
                        width: 105,
                        decoration: const BoxDecoration(
                            color: Color(0xFFFADFB9),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(dateContext,
                            style: TextStyle(fontSize: textSM)));
                  } else {
                    return const SizedBox();
                  }
                }

                if (contents[index].questionFrom == "me") {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getDateChip(),
                        Container(
                            alignment: Alignment.topLeft,
                            width: fullWidth,
                            padding: EdgeInsets.all(paddingSM - 2),
                            margin: EdgeInsets.only(
                                left: fullWidth * 0.2,
                                right: paddingSM,
                                top: paddingXSM),
                            decoration: const BoxDecoration(
                                color: Color(0xFFE88F34),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            child: Text(contents[index].msgBody,
                                style: TextStyle(color: whitebg))),
                        getHourText(
                            contents[index].createdAt,
                            EdgeInsets.only(
                                right: paddingSM, top: paddingXSM / 2),
                            Alignment.centerRight)
                      ]);
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getDateChip(),
                        Container(
                            width: fullWidth,
                            padding: EdgeInsets.all(paddingSM - 2),
                            margin: EdgeInsets.only(
                                right: fullWidth * 0.2,
                                left: paddingSM,
                                top: paddingXSM),
                            decoration: const BoxDecoration(
                                color: Color(0xFFE5E5EA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getMsgBody(contents[index].msgBody),
                                  Text(contents[index].msgReply)
                                ])),
                        getHourText(
                            contents[index].createdAt,
                            EdgeInsets.only(
                                left: paddingSM, top: paddingXSM / 2),
                            Alignment.centerLeft)
                      ]);
                }
              }));
    } else {
      return Center(child: getNoDataContainer("Message not found"));
    }
  }
}

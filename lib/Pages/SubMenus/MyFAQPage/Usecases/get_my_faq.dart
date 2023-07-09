import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Skeletons/faq.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';

import 'package:mi_fik/Modules/Variables/style.dart';

class GetMyFAQ extends StatefulWidget {
  GetMyFAQ({Key key, this.scrollCtrl}) : super(key: key);
  ScrollController scrollCtrl;

  @override
  StateGetMyFAQ createState() => StateGetMyFAQ();
}

class StateGetMyFAQ extends State<GetMyFAQ> {
  QuestionQueriesService apiQuery;
  int page = 1;
  List<MyQuestionModel> contents = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String dateChipBefore = "";

  @override
  void initState() {
    super.initState();
    widget.scrollCtrl = ScrollController()
      ..addListener(() {
        if (widget.scrollCtrl.offset ==
            widget.scrollCtrl.position.maxScrollExtent) {
          loadMoreFAQ();
        }
      });

    apiQuery = QuestionQueriesService();
    loadMoreFAQ();
  }

  Future<void> loadMoreFAQ() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<MyQuestionModel> newHistory = await apiQuery.getMyFAQ(page);
      if (newHistory != null) {
        page++;
        contents.addAll(newHistory);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    page = 1;
    contents.clear();

    loadMoreFAQ();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _refreshIndicatorKey,
      maintainBottomViewPadding: false,
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: spaceXMD),
          itemCount: contents.length + 1,
          controller: widget.scrollCtrl,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (index < contents.length) {
              return _buildFAQItem(contents[index]);
            } else if (isLoading) {
              return const FAQSkeleton();
            } else {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: spaceLG),
                  child: Text("No more item to show".tr,
                      style: TextStyle(fontSize: textSM)));
            }
          },
        ),
      ),
    );
  }

  Widget _buildFAQItem(MyQuestionModel content) {
    // double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getMsgBody(String text) {
      if (text != null) {
        return Container(
            margin: EdgeInsets.only(bottom: spaceSM),
            padding: EdgeInsets.all(spaceSM),
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryLightBG.withOpacity(0.7),
                // border: Border(
                //     left: BorderSide(color: primaryColor)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(roundedMD),
                    bottomRight: Radius.circular(roundedMD))),
            child: Text(text,
                style: TextStyle(color: darkColor, fontSize: textMD)));
      } else {
        return const SizedBox();
      }
    }

    Widget getDateChip() {
      var dt = content.createdAt;
      var date = DateTime.parse(dt);

      String check = ("${date.year}${date.month}${date.day}");
      if (dateChipBefore != check) {
        dateChipBefore = check;
        var dateContext = DateFormat("dd MMM yyyy").format(date);
        var yesterdayContext =
            DateFormat("dd MMM yyyy").format(date.add(const Duration(days: 1)));

        if (getToday("date") == dateContext) {
          dateContext = "Today".tr;
        } else if (getToday("date") == yesterdayContext) {
          dateContext = "Yesterday".tr;
        }

        return Container(
            margin: EdgeInsets.only(top: spaceXMD),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: spaceSM - 2),
            width: 105,
            decoration: const BoxDecoration(
                color: Color(0xFFFADFB9),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(dateContext, style: TextStyle(fontSize: textSM)));
      } else {
        return const SizedBox();
      }
    }

    if (content.questionFrom == "me") {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        getDateChip(),
        Container(
            alignment: Alignment.topLeft,
            width: fullWidth,
            padding: EdgeInsets.all(spaceXMD - 2),
            margin: EdgeInsets.only(
                left: fullWidth * 0.2, right: spaceXMD, top: spaceSM),
            decoration: BoxDecoration(
                color: const Color(0xFFE88F34),
                borderRadius: BorderRadius.all(Radius.circular(roundedMD))),
            child: Text(content.msgBody, style: TextStyle(color: whiteColor))),
        getHourText(
            content.createdAt,
            EdgeInsets.only(right: spaceXMD, top: spaceSM / 2),
            Alignment.centerRight)
      ]);
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        getDateChip(),
        Container(
            width: fullWidth,
            padding: EdgeInsets.all(spaceXMD - 2),
            margin: EdgeInsets.only(
                right: fullWidth * 0.2, left: spaceXMD, top: spaceSM),
            decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.all(Radius.circular(roundedMD))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getMsgBody(content.msgReply),
                  Text("${content.msgBody} ")
                ])),
        getHourText(
            content.createdAt,
            EdgeInsets.only(left: spaceXMD, top: spaceSM / 2),
            Alignment.centerLeft)
      ]);
    }
  }
}

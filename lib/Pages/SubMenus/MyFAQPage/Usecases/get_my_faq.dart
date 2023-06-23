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
          padding: EdgeInsets.only(bottom: paddingSM),
          itemCount: contents.length + 1,
          controller: widget.scrollCtrl,
          itemBuilder: (BuildContext context, int index) {
            if (index < contents.length) {
              return _buildFAQItem(contents[index]);
            } else if (isLoading) {
              return const FAQSkeleton();
            } else {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: paddingMD),
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
            margin: EdgeInsets.only(bottom: paddingXSM),
            padding: EdgeInsets.all(paddingXSM),
            width: double.infinity,
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
            margin: EdgeInsets.only(top: paddingSM),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: paddingXSM - 2),
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
            padding: EdgeInsets.all(paddingSM - 2),
            margin: EdgeInsets.only(
                left: fullWidth * 0.2, right: paddingSM, top: paddingXSM),
            decoration: const BoxDecoration(
                color: Color(0xFFE88F34),
                borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Text(content.msgBody, style: TextStyle(color: whitebg))),
        getHourText(
            content.createdAt,
            EdgeInsets.only(right: paddingSM, top: paddingXSM / 2),
            Alignment.centerRight)
      ]);
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        getDateChip(),
        Container(
            width: fullWidth,
            padding: EdgeInsets.all(paddingSM - 2),
            margin: EdgeInsets.only(
                right: fullWidth * 0.2, left: paddingSM, top: paddingXSM),
            decoration: const BoxDecoration(
                color: Color(0xFFE5E5EA),
                borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getMsgBody(content.msgBody),
                  Text(content.msgReply)
                ])),
        getHourText(
            content.createdAt,
            EdgeInsets.only(left: paddingSM, top: paddingXSM / 2),
            Alignment.centerLeft)
      ]);
    }
  }
}

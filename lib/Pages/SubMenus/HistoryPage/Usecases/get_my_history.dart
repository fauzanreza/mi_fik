import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Skeletons/history.dart';

import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_history.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_history.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetMyHistory extends StatefulWidget {
  GetMyHistory({Key key, this.scrollCtrl}) : super(key: key);
  ScrollController scrollCtrl;

  @override
  StateGetMyHistory createState() => StateGetMyHistory();
}

class StateGetMyHistory extends State<GetMyHistory> {
  HistoryQueriesService apiQuery;
  int page = 1;
  List<HistoryModel> contents = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    widget.scrollCtrl = ScrollController()
      ..addListener(() {
        if (widget.scrollCtrl.offset ==
            widget.scrollCtrl.position.maxScrollExtent) {
          loadMoreHistory();
        }
      });

    apiQuery = HistoryQueriesService();
    loadMoreHistory();
  }

  Future<void> loadMoreHistory() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<HistoryModel> newHistory = await apiQuery.getMyHistory(page);
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

    loadMoreHistory();
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
          itemBuilder: (BuildContext context, int index) {
            if (index < contents.length) {
              return _buildHistoryItem(contents[index]);
            } else if (isLoading) {
              return const HistorySkeleton();
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

  Widget _buildHistoryItem(HistoryModel content) {
    return Container(
      margin: EdgeInsets.fromLTRB(spaceXMD, spaceXMD, spaceXMD, 0),
      padding: EdgeInsets.all(spaceXMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: const Offset(3.0, 3.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                content.historyType,
                style: TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.w500,
                  fontSize: textXMD,
                ),
              ),
              const Spacer(),
              Text(
                getItemTimeString(DateTime.parse(content.createdAt)),
                style: TextStyle(
                  color: semidarkColor,
                  fontSize: textSM * 1.1,
                ),
              ),
            ],
          ),
          SizedBox(height: spaceXMD),
          Text(
            content.historyBody,
            style: TextStyle(
              color: semidarkColor,
              fontSize: textSM * 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

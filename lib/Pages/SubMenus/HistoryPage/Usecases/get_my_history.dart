import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Container/nodata.dart';

import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_history.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_history.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetMyHistory extends StatefulWidget {
  const GetMyHistory({Key key}) : super(key: key);

  @override
  StateGetMyHistory createState() => StateGetMyHistory();
}

class StateGetMyHistory extends State<GetMyHistory> {
  HistoryQueriesService apiQuery;
  int page = 1;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    apiQuery = HistoryQueriesService();
  }

  Future<void> refreshData() async {
    page = 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshData,
        child: FutureBuilder(
          future: apiQuery.getMyHistory(page),
          builder: (BuildContext context,
              AsyncSnapshot<List<HistoryModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}",
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<HistoryModel> contents = snapshot.data;
              return _buildListView(contents);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<HistoryModel> contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    if (contents != null) {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: paddingMD),
          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.only(
                    left: paddingSM, right: paddingSM, top: paddingSM),
                padding: EdgeInsets.all(paddingSM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 128, 128, 128)
                          .withOpacity(0.2),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset: const Offset(
                        3.0,
                        3.0,
                      ),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(contents[index].historyType,
                            style: TextStyle(
                                color: blackbg,
                                fontWeight: FontWeight.w500,
                                fontSize: textMD)),
                        const Spacer(),
                        Text(getItemTimeString(contents[index].createdAt),
                            style: TextStyle(
                                color: semiblackbg, fontSize: textSM * 1.1))
                      ],
                    ),
                    SizedBox(height: paddingSM),
                    Text(contents[index].historyBody,
                        style: TextStyle(
                            color: semiblackbg, fontSize: textSM * 1.1))
                  ],
                ));
          });
    } else {
      return Center(child: getNoDataContainer("History not found", 120));
    }
  }
}

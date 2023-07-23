import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/queries.dart';

import 'package:mi_fik/Modules/APIs/QuestionApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAllQuestion extends StatefulWidget {
  const GetAllQuestion({Key key}) : super(key: key);

  @override
  StateGetAllQuestion createState() => StateGetAllQuestion();
}

class StateGetAllQuestion extends State<GetAllQuestion> {
  QuestionQueriesService apiQuery;

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
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshData,
          child: FutureBuilder(
            future: apiQuery.getActiveFAQ(),
            builder: (BuildContext context,
                AsyncSnapshot<List<QuestionBodyModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something wrong"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<QuestionBodyModel> contents = snapshot.data;
                return _buildListView(contents);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Widget _buildListView(List<QuestionBodyModel> contents) {
    // double fullHeight = MediaQuery.of(context).size.height;
    // double fullWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
        itemCount: contents.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: hoverBG, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ExpansionTile(
              tilePadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: spaceXMD),
              childrenPadding: EdgeInsets.only(
                  left: spaceXMD, bottom: spaceXMD, right: spaceXMD),
              initiallyExpanded: false,
              iconColor: primaryColor,
              textColor: darkColor,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.topLeft,
              title: Text(ucFirst(contents[index].questionBody),
                  style: TextStyle(fontSize: textXMD - 1)),
              subtitle: Text(ucFirst(contents[index].questionType),
                  style: TextStyle(color: shadowColor)),
              children: [
                Text(
                  "Answer".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: textXMD,
                      color: successBG),
                ),
                Text(ucFirst(contents[index].questionAnswer))
              ],
            ),
          );
        });
  }
}

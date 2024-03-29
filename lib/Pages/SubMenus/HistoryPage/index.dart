import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Pages/SubMenus/HistoryPage/Components/get_my_history.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  StateHistoryPage createState() => StateHistoryPage();
}

class StateHistoryPage extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("History".tr, () {
        Get.toNamed(CollectionRoute.profile);
      }),
      body: const GetMyHistory(),
    );
  }
}

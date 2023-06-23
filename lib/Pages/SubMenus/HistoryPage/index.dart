import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/HistoryPage/Usecases/get_my_history.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/index.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  StateHistoryPage createState() => StateHistoryPage();
}

class StateHistoryPage extends State<HistoryPage> {
  bool showBackToTopButton = false;
  ScrollController scrollCtrl;

  @override
  void dispose() {
    //scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("History".tr, () {
        Get.offAll(() => const ProfilePage());
      }),
      body: GetMyHistory(scrollCtrl: scrollCtrl),
    );
  }
}

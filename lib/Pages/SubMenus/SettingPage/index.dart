import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/SettingPage/Components/set_language.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  StateSettingPage createState() => StateSettingPage();
}

class StateSettingPage extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Setting".tr, () {
        Get.back();
      }),
      body: ListView(
        children: const [SetLanguage()],
      ),
    );
  }
}

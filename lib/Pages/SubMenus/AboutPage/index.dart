import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/Components/get_about.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/Components/post_feedback.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  StateAboutPage createState() => StateAboutPage();
}

class StateAboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("About Us".tr, () {
        Get.to(() => const BottomBar());
      }),
      body: ListView(children: const [
        GetAbout(),
        PostFeedback(),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/Usecases/get_about.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/Usecases/post_feedback.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("About Us", () {
        Navigator.pop(context);
      }),
      body: ListView(children: const [GetAbout(), PostFeedback()]),
    );
  }
}

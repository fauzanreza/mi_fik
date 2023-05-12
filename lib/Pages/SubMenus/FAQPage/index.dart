import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Usecases/get_question.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/Usecases/post_question.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key key}) : super(key: key);

  @override
  _FAQPage createState() => _FAQPage();
}

class _FAQPage extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: getAppbar("Frequently Asked Question"),
        body: const GetAllQuestion(),
        floatingActionButton: const PostQuestion());
  }
}

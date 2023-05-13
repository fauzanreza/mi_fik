import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class MyFAQPage extends StatefulWidget {
  const MyFAQPage({Key key}) : super(key: key);

  @override
  _MyFAQPage createState() => _MyFAQPage();
}

class _MyFAQPage extends State<MyFAQPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("My Question"),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: successbg,
        tooltip: "Ask a question",
        child: const Icon(Icons.headset_mic),
      ),
    );
  }
}

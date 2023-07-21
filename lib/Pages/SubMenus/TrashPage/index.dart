import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({Key key}) : super(key: key);

  @override
  StateTrashPage createState() => StateTrashPage();
}

class StateTrashPage extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Trash".tr, () {
        Get.back();
      }),
      body: ListView(
        children: const [],
      ),
    );
  }
}

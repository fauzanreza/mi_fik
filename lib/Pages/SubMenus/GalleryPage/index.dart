import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key key}) : super(key: key);

  @override
  StateGalleryPage createState() => StateGalleryPage();
}

class StateGalleryPage extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Gallery".tr, () {
        Get.back();
      }),
      body: ListView(
        children: [],
      ),
    );
  }
}

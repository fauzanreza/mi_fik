import 'package:flutter/material.dart';

class PostEvent extends StatefulWidget {
  PostEvent({Key key, this.text}) : super(key: key);
  String text;

  @override
  _PostEvent createState() => _PostEvent();
}

class _PostEvent extends State<PostEvent> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
    );
  }
}

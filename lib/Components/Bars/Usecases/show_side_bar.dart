import 'package:flutter/material.dart';

Widget showSideBar(var scaffoldKey, var clr) {
  return Container(
    margin: EdgeInsets.zero,
    child: Row(children: [
      IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.menu, size: 32, color: clr),
        tooltip: 'Others',
        onPressed: () => scaffoldKey.currentState.openDrawer(),
      ),
      const Spacer(),
      IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.notifications, size: 32, color: clr),
        tooltip: 'Notification',
        onPressed: () => scaffoldKey.currentState.openEndDrawer(),
      ),
    ]),
  );
}

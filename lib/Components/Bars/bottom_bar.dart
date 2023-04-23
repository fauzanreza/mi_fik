import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/CalendarPage/index.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/index.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/index.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const SchedulePage(),
    const CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: roundedLG,
            topLeft: roundedLG,
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home), //Change if there's an asset.
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule), //Change if there's an asset.
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), //Change if there's an asset.
                label: 'Calendar',
              ),
            ],
            backgroundColor: whitebg,
            selectedLabelStyle: const TextStyle(fontSize: 14),
            selectedItemColor: primaryColor,
            unselectedItemColor: primaryColor,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ));
  }
}

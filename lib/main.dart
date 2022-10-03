//Plugin.
import 'package:flutter/material.dart';

//Main Menu.
import 'package:mi_fik/Calendar/index.dart';
import 'package:mi_fik/Home/index.dart';
import 'package:mi_fik/Schedule/index.dart';

void main() {
  runApp(const MyApp());
}

//Style guide.
var primaryColor = const Color(0xFFFB8C00);
var mainbg = const Color(0xFFD9D9D9);
var whitebg = const Color(0xFFFFFFFF);
var blackbg = const Color(0xFF414141);

var roundedLG = const Radius.circular(18); //For navbar, ...
var roundedMd = const Radius.circular(10); //For container, ...
double roundedMd2 = 10; //For container, ...
double roundedLG2 = 14; //For container, ...

double textXL = 32;
double textLG = 22;
double textMD = 16;
double textSM = 13;
double textXSM = 11.5;
double textXXSM = 9.5;

double btnHeightMD = 55;

double marginMD = 25; //For home content (MB)
double marginMT = 12; //For detail content (MT)
double paddingMD = 20;
double marginHZ = 4; //For horizontal listview

double iconLG = 32; //For floating add btn, ...
double iconMD = 26; //For link or file btn, ...

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: mainbg),
      home: const NavBar(), //For now.
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const SchedulePage(),
    const HomePage(),
    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: roundedLG,
            topLeft: roundedLG,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule), //Change if there's an asset.
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home), //Change if there's an asset.
                label: 'Home',
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
                _selectedIndex = index;
              });
            },
          ),
        ));
  }
}

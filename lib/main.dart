//Plugin.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Main Menu.
import 'package:mi_fik/Calendar/index.dart';
import 'package:mi_fik/Home/index.dart';
import 'package:mi_fik/Landing/Login/index.dart';
import 'package:mi_fik/Schedule/index.dart';

void main() {
  runApp(const MyApp());
}

//Style guide.
var primaryColor = const Color(0xFFFB8C00);
var dangerColor = const Color(0xFFFB5E5B);
var mainbg = const Color.fromARGB(255, 232, 232, 232);
var whitebg = const Color(0xFFFFFFFF);
var blackbg = const Color(0xFF414141);
var greybg = const Color.fromARGB(255, 118, 118, 118);

var roundedLG = const Radius.circular(18); //For navbar, ...
var roundedMd = const Radius.circular(10); //For container, ...
double roundedMd2 = 10; //For container, ...
double roundedLG2 = 14; //For container, ...

double textXL = 32;
double textXLG = 25;
double textLG = 22;
double textMD = 16;
double textSM = 13;
double textXSM = 11.5;
double textXXSM = 9.5;

double btnHeightMD = 55;

double marginMD = 25; //For home content (MB)
double marginMT = 12; //For detail content (MT)
double paddingMD = 20;
double paddingSM = 15;
double paddingXSM = 10;
double marginHZ = 4; //For horizontal listview

double iconLG = 32; //For floating add btn, ...
double iconMD = 26; //For link or file btn, ...

//Others variable
List archieveVal = []; //Need to be fixed
DateTime slctSchedule = DateTime.now();
int passIdUser = 1; //For now.
int passIdContent;
final locDetailCtrl = TextEditingController();
var locCoordinateCtrl = null;
final selectedTag = [];
var selectedArchiveName;
var selectedArchiveId;
int selectedIndex = 0;

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Lock device on portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: mainbg),
      home: const LoginPage(), //For now.
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> _widgetOptions = <Widget>[
    const SchedulePage(),
    const HomePage(),
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
                selectedIndex = index;
              });
            },
          ),
        ));
  }
}

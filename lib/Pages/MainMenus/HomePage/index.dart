import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/custom.dart';
import 'package:mi_fik/Components/Bars/Usecases/show_side_bar.dart';
import 'package:mi_fik/Components/Bars/left_bar.dart';
import 'package:mi_fik/Components/Bars/right_bar.dart';
import 'package:mi_fik/Components/Button/navigation.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_content.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/get_location.dart';
import 'package:mi_fik/Components/Typography/show_greeting.dart';
import 'package:mi_fik/Pages/MainMenus/SchedulePage/Usecases/post_task.dart';
import 'package:mi_fik/Pages/SubMenus/AddPostPage/index.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  StateHomePage createState() => StateHomePage();
}

class StateHomePage extends State<HomePage> {
  ContentQueriesService queryService;
  int page = 1;
  List<ContentHeaderModel> contents = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<Role> getTokenNLoc() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role_general_key');
    await checkGps(getCurrentLocationDetails());
    return Role(role: role);
  }

  Future<void> refreshData() async {
    page = 1;
    contents.clear();
    loadMoreContent();
  }

  ScrollController scrollCtrl;

  @override
  void initState() {
    super.initState();
    queryService = ContentQueriesService();
    scrollCtrl = ScrollController()
      ..addListener(() {
        if (scrollCtrl.offset == scrollCtrl.position.maxScrollExtent) {
          loadMoreContent();
        }
      });
    loadMoreContent();
  }

  Future<void> loadMoreContent() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<ContentHeaderModel> newHistory =
          await queryService.getAllContentHeader(
              getTagFilterContent(selectedTagFilterContent),
              sortingHomepageContent,
              getWhereDateFilter(filterDateStart, filterDateEnd),
              getFindFilter(searchingContent),
              page++);
      if (newHistory != null) {
        contents.addAll(newHistory);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    //scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: const LeftBar(),
          drawerScrimColor: primaryColor.withOpacity(0.35),
          endDrawer: const RightBar(),
          body: CustomPaint(
              painter: CirclePainter(),
              child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: refreshData,
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: fullHeight * 0.04),
                      itemCount: 1,
                      controller: scrollCtrl,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          showSideBar(scaffoldKey, whiteColor),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getGreeting(getToday("part"), whiteColor),
                                  getTitleJumbo(getToday("clock"), whiteColor),
                                  SizedBox(height: fullHeight * 0.05),
                                  Row(
                                    children: [
                                      getSubTitleMedium(getToday("date"),
                                          whiteColor, TextAlign.start),
                                      const Spacer(),
                                      const GetLocation()
                                    ],
                                  )
                                ]),
                          ),
                          Container(
                            //height: double.infinity,
                            margin: const EdgeInsets.only(top: 10.0),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: hoverBG,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(roundedLG),
                                  topRight: Radius.circular(roundedLG)),
                            ),
                            child: GetContent(
                                scrollCtrl: scrollCtrl, item: contents),
                          )
                        ]);
                      }))),
          floatingActionButton: const GetRoleFeature(),
        ));
  }
}

class GetRoleFeature extends StatefulWidget {
  const GetRoleFeature({Key key}) : super(key: key);

  @override
  StateGetRole createState() => StateGetRole();
}

class StateGetRole extends State<GetRoleFeature> {
  ContentQueriesService queryService;
  int page = 1;
  List<ContentHeaderModel> contents = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Role> getTokenNLoc() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role_general_key');
    await checkGps(getCurrentLocationDetails());
    return Role(role: role);
  }

  Future<void> refreshData() async {
    page = 1;
    contents.clear();
    loadMoreContent();
  }

  ScrollController scrollCtrl;

  @override
  void initState() {
    super.initState();
    queryService = ContentQueriesService();
    scrollCtrl = ScrollController()
      ..addListener(() {
        if (scrollCtrl.offset == scrollCtrl.position.maxScrollExtent) {
          loadMoreContent();
        }
      });
    loadMoreContent();
  }

  Future<void> loadMoreContent() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<ContentHeaderModel> newHistory =
          await queryService.getAllContentHeader(
              getTagFilterContent(selectedTagFilterContent),
              sortingHomepageContent,
              getWhereDateFilter(filterDateStart, filterDateEnd),
              getFindFilter(searchingContent),
              page++);
      if (newHistory != null) {
        contents.addAll(newHistory);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    //scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Role>(
        future: getTokenNLoc(),
        builder: (context, snapshot) {
          getRoleFeature(String role) {
            if (role != "Student") {
              return SpeedDial(
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: primaryColor,
                  overlayColor: primaryColor,
                  overlayOpacity: 0.4,
                  children: [
                    getSpeeDialChild("New Task".tr, context, const PostTask(),
                        Icons.note_add_outlined),
                    getSpeeDialChild("New Post".tr, context, const AddPost(),
                        Icons.post_add_outlined),
                  ],
                  child: Icon(Icons.add, size: iconLG));
            } else {
              return SpeedDial(
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: primaryColor,
                  overlayColor: primaryColor,
                  overlayOpacity: 0.4,
                  children: [
                    getSpeeDialChild("New Task".tr, context, const PostTask(),
                        Icons.note_add_outlined),
                  ],
                  child: Icon(Icons.add, size: iconLG));
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            String role = snapshot.data.role;
            return getRoleFeature(role);
          } else {
            return const SizedBox();
          }
        });
  }
}

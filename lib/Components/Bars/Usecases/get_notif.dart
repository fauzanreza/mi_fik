import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_notification.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_notification.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetNotification extends StatefulWidget {
  const GetNotification({Key key}) : super(key: key);

  @override
  StateGetNotification createState() => StateGetNotification();
}

class StateGetNotification extends State<GetNotification> {
  NotificationQueriesService apiService;
  int page = 1;
  List<NotificationModel> contents = [];
  bool isLoading = false;
  ScrollController scrollCtrl;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    scrollCtrl = ScrollController()
      ..addListener(() {
        if (scrollCtrl.offset == scrollCtrl.position.maxScrollExtent) {
          loadMoreNotif();
        }
      });

    apiService = NotificationQueriesService();
    loadMoreNotif();
  }

  Future<void> loadMoreNotif() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<NotificationModel> newHistory =
          await apiService.getAllNotification(page);
      if (newHistory != null) {
        page++;
        contents.addAll(newHistory);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    page = 1;
    contents.clear();

    loadMoreNotif();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      key: _refreshIndicatorKey,
      maintainBottomViewPadding: false,
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: spaceXMD),
          itemCount: contents.length + 1,
          controller: scrollCtrl,
          itemBuilder: (BuildContext context, int index) {
            if (index < contents.length) {
              return _buildNotifItem(contents[index]);
            } else if (isLoading) {
              return const ContentSkeleton1();
            } else {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: spaceLG),
                  child: Text("No more item to show".tr,
                      style:
                          TextStyle(fontSize: textSM + 1, color: whiteColor)));
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotifItem(NotificationModel notifs) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.fromLTRB(spaceXMD, 0, spaceXMD, spaceSM),
        padding: EdgeInsets.symmetric(vertical: spaceSM),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
        ),
        child: ListTile(
          title: Text(notifs.notifTitle,
              style: TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textSM + 1)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notifs.notifBody,
                  style: TextStyle(color: darkColor, fontSize: textSM)),
              const SizedBox(height: 5),
              Text(getItemTimeString(notifs.createdAt),
                  style: TextStyle(color: shadowColor, fontSize: textSM))
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.chevron_right_rounded,
                color: primaryColor, size: iconXL),
            tooltip: 'See Detail',
            onPressed: () {
              showDialog<String>(
                  context: context,
                  barrierColor: primaryColor.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                          insetPadding: EdgeInsets.all(spaceSM),
                          contentPadding: EdgeInsets.all(spaceSM),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(roundedLG))),
                          content: SizedBox(
                              height: fullHeight * 0.75,
                              width: fullWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.close),
                                        tooltip: 'Back',
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: spaceSM),
                                      children: [
                                        Text(notifs.notifTitle,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: spaceJumbo,
                                        ),
                                        Text(notifs.notifBody),
                                        SizedBox(
                                          height: spaceJumbo,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      margin: EdgeInsets.all(spaceSM),
                                      alignment: Alignment.topRight,
                                      child: Text(
                                          getItemTimeString(notifs.createdAt),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: textMD)),
                                    )
                                  ])));
                    });
                  });
            },
          ),
        ));
  }
}

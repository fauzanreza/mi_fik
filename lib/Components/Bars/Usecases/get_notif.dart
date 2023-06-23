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

class StateGetNotification extends State<GetNotification>
    with TickerProviderStateMixin {
  NotificationQueriesService apiService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    apiService = NotificationQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllNotification(1),
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<NotificationModel> notifs = snapshot.data;
            return _buildListView(notifs);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<NotificationModel> notifs) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshData,
        child: ListView.builder(
            itemCount: notifs.length,
            padding: EdgeInsets.symmetric(
                vertical: paddingMD, horizontal: paddingXSM / 2),
            itemBuilder: (context, index) {
              return Container(
                  margin:
                      EdgeInsets.fromLTRB(paddingSM, 0, paddingSM, paddingXSM),
                  padding: EdgeInsets.symmetric(vertical: paddingXSM),
                  decoration: BoxDecoration(
                    color: whitebg,
                    borderRadius: BorderRadius.all(roundedMd),
                  ),
                  child: ListTile(
                    title: Text(notifs[index].notifTitle,
                        style: TextStyle(
                            color: blackbg,
                            fontWeight: FontWeight.bold,
                            fontSize: textSM + 1)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notifs[index].notifBody,
                            style: TextStyle(color: blackbg, fontSize: textSM)),
                        const SizedBox(height: 5),
                        Text(getItemTimeString(notifs[index].createdAt),
                            style: TextStyle(color: greybg, fontSize: textSM))
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
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                    insetPadding: EdgeInsets.all(paddingXSM),
                                    contentPadding: EdgeInsets.all(paddingXSM),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(roundedLG)),
                                    content: SizedBox(
                                        height: fullHeight * 0.75,
                                        width: fullWidth,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    horizontal: paddingXSM),
                                                children: [
                                                  Text(notifs[index].notifTitle,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  SizedBox(
                                                    height: paddingLg,
                                                  ),
                                                  Text(notifs[index].notifBody),
                                                  SizedBox(
                                                    height: paddingLg,
                                                  ),
                                                ],
                                              )),
                                              Container(
                                                margin:
                                                    EdgeInsets.all(paddingXSM),
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                    getItemTimeString(
                                                        notifs[index]
                                                            .createdAt),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: textMD)),
                                              )
                                            ])));
                              });
                            });
                      },
                    ),
                  ));
            }));
  }
}

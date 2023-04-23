import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Models/Notifications/Notifications.dart';
import 'package:mi_fik/Modules/Services/Queries/NotificationQueries.dart';
import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetNotification extends StatefulWidget {
  const GetNotification({Key key}) : super(key: key);

  @override
  _GetNotification createState() => _GetNotification();
}

class _GetNotification extends State<GetNotification>
    with TickerProviderStateMixin {
  NotificationQueriesService apiService;

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
        future: apiService.getMyNotif(passIdUser, 1),
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
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: notifs.map((notif) {
      return Container(
          margin: EdgeInsets.only(
              bottom: paddingXSM, left: paddingXSM, right: paddingXSM),
          padding: EdgeInsets.all(paddingSM),
          decoration: BoxDecoration(
            color: whitebg,
            borderRadius: BorderRadius.all(roundedMd),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: fullWidth * 0.6, //Check this ...
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: getNotifSender(
                                  notif.adminName, notif.userName),
                              style: TextStyle(
                                  color: blackbg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSM + 1)),
                          TextSpan(
                              text: ' ${notif.notifBody}',
                              style: TextStyle(
                                  color: blackbg, fontSize: textSM + 1)),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: marginMT * 0.4),
                        child: Text(getItemTimeString(notif.createdAt),
                            style:
                                TextStyle(color: greybg, fontSize: textSM + 1)))
                  ],
                ),
              ),
              Container(
                transform:
                    Matrix4.translationValues(fullWidth * 0.525, 0.0, 0.0),
                child: IconButton(
                  icon: Icon(Icons.chevron_right_rounded,
                      color: primaryColor, size: 32),
                  tooltip: 'See Detail',
                  onPressed: () {},
                ),
              ),
            ],
          ));
    }).toList());
  }
}

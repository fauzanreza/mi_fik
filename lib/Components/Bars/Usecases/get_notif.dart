import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_notification.dart';
import 'package:mi_fik/Modules/APIs/SystemApi/Services/query_notification.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
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
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: notifs.map((notif) {
      return Container(
          margin: EdgeInsets.only(
              bottom: paddingXSM, left: paddingSM, right: paddingSM),
          padding: EdgeInsets.symmetric(vertical: paddingXSM),
          decoration: BoxDecoration(
            color: whitebg,
            borderRadius: BorderRadius.all(roundedMd),
          ),
          child: ListTile(
            title: Text(notif.notifTitle,
                style: TextStyle(
                    color: blackbg,
                    fontWeight: FontWeight.bold,
                    fontSize: textSM + 1)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.notifBody,
                    style: TextStyle(color: blackbg, fontSize: textSM)),
                const SizedBox(height: 5),
                Text(getItemTimeString(notif.createdAt),
                    style: TextStyle(color: greybg, fontSize: textSM))
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right_rounded,
                  color: primaryColor, size: iconLG),
              tooltip: 'See Detail',
              onPressed: () {},
            ),
          ));
    }).toList());
  }
}

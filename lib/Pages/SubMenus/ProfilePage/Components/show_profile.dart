import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/ProfilePage/Components/edit_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';

class ShowProfile extends StatelessWidget {
  const ShowProfile({Key key}) : super(key: key);

  Future<UserProfileLeftBar> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username_key');
    final image = prefs.getString('image_key');
    final role = prefs.getString('role_general_key');

    if (role != null && image != null && username != null) {
      return UserProfileLeftBar(
          username: username, image: image, roleGeneral: role);
    } else {
      await getDestroyTrace(false);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<UserProfileLeftBar>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            String username = snapshot.data.username;
            String image = snapshot.data.image;
            String role = snapshot.data.roleGeneral;

            return Container(
              width: fullWidth,
              padding: EdgeInsets.fromLTRB(spaceSM, spaceSM, spaceSM, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                          margin: EdgeInsets.all(spaceLG),
                          child: getProfileImageSideBar(fullWidth, 0.3, image)),
                      const EditImage(),
                    ]),
                    Text("@$username",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: textXMD + 2,
                            fontWeight: FontWeight.w500)),
                    Container(
                        margin: EdgeInsets.only(
                            top: spaceMini, left: spaceMini, right: spaceMini),
                        padding: EdgeInsets.symmetric(
                            vertical: spaceSM / 2, horizontal: spaceXMD),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(roundedSM))),
                        child: Text(role,
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: textXMD + 2,
                                fontWeight: FontWeight.w500)))
                  ]),
            );
          } else {
            return Container(
                width: fullWidth,
                padding: EdgeInsets.fromLTRB(spaceSM, spaceXMD, spaceSM, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: fullWidth * 0.35),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                                height: fullHeight * 0.15,
                                width: fullHeight * 0.15,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(roundedCircle))),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: fullWidth * 0.325, top: spaceXMD),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                                height: 35,
                                width: fullHeight * 0.175,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(roundedMD))),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: fullWidth * 0.325, top: spaceXSM),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                                height: 35,
                                width: fullHeight * 0.175,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(roundedMD))),
                          ))
                    ]));
          }
        });
  }
}

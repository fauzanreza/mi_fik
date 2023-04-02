import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';

class LeftBar extends StatelessWidget {
  const LeftBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Drawer(
        backgroundColor: primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: fullHeight * 0.7,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: fullWidth,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: EdgeInsets.all(paddingXSM),
                              decoration: BoxDecoration(
                                color: whitebg,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                              child: ClipRRect(
                                child: Image.asset(
                                    'assets/icon/default-profile.png',
                                    width: fullWidth * 0.15),
                              ),
                            ),
                            Text("Adolfhus Hitler",
                                style: TextStyle(
                                    color: whitebg,
                                    fontSize: textMD,
                                    fontWeight: FontWeight.w500)),
                            Text("Dosen FIK",
                                style: TextStyle(
                                    color: whitebg,
                                    fontSize: textMD,
                                    fontWeight: FontWeight.w500))
                          ]),
                    ),
                    Container(
                      width: fullWidth,
                      margin: EdgeInsets.symmetric(horizontal: paddingXSM),
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {},
                        icon: Icon(Icons.person, size: textXLG, color: whitebg),
                        label: Text("Profile",
                            style: TextStyle(color: whitebg, fontSize: textMD)),
                        style: ElevatedButton.styleFrom(),
                      ),
                    ),
                    Container(
                      width: fullWidth,
                      margin: EdgeInsets.symmetric(horizontal: paddingXSM),
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {},
                        icon: Icon(Icons.folder_open,
                            size: textXLG, color: whitebg),
                        label: Text("Archive",
                            style: TextStyle(color: whitebg, fontSize: textMD)),
                        style: ElevatedButton.styleFrom(),
                      ),
                    ),
                    Container(
                      width: fullWidth,
                      margin: EdgeInsets.symmetric(horizontal: paddingXSM),
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {},
                        icon:
                            Icon(Icons.person, //Change w/ asset icon from figma
                                size: textXLG,
                                color: whitebg),
                        label: Text("Role",
                            style: TextStyle(color: whitebg, fontSize: textMD)),
                        style: ElevatedButton.styleFrom(),
                      ),
                    ),
                    Container(
                      width: fullWidth,
                      margin: EdgeInsets.only(
                          bottom: paddingXSM,
                          left: paddingXSM,
                          right: paddingXSM),
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {},
                        icon: Icon(Icons.checklist,
                            size: textXLG, color: whitebg),
                        label: Text("Schedule",
                            style: TextStyle(color: whitebg, fontSize: textMD)),
                        style: ElevatedButton.styleFrom(),
                      ),
                    )
                  ]),
            ),
            Container(
              width: fullWidth,
              margin: EdgeInsets.symmetric(horizontal: paddingXSM),
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {},
                icon: Icon(Icons.question_answer_outlined,
                    size: textXLG, color: whitebg),
                label: Text("FAQ",
                    style: TextStyle(color: whitebg, fontSize: textMD)),
                style: ElevatedButton.styleFrom(),
              ),
            ),
            Container(
              width: fullWidth,
              margin: EdgeInsets.symmetric(horizontal: paddingXSM),
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {},
                icon: Icon(Icons.settings, size: textXLG, color: whitebg),
                label: Text("Setting",
                    style: TextStyle(color: whitebg, fontSize: textMD)),
                style: ElevatedButton.styleFrom(),
              ),
            ),
            Container(
              width: fullWidth,
              margin: EdgeInsets.only(
                  bottom: paddingXSM, left: paddingXSM, right: paddingXSM),
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {},
                icon: Icon(Icons.logout, size: textXLG, color: whitebg),
                label: Text("Log Out",
                    style: TextStyle(color: whitebg, fontSize: textMD)),
                style: ElevatedButton.styleFrom(),
              ),
            )
          ],
        ));
  }
}

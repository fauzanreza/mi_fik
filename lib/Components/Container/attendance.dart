import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/widget.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAttendanceContainer extends StatefulWidget {
  const GetAttendanceContainer({Key key, this.width, this.content, this.servc})
      : super(key: key);
  final double width;
  final dynamic content;
  final ContentCommandsService servc;

  @override
  StateGetAttendanceContainer createState() => StateGetAttendanceContainer();
}

class StateGetAttendanceContainer extends State<GetAttendanceContainer> {
  Widget getUsername(u1, u2) {
    String username = " ";
    if (u1 != null) {
      username = "@$u1";
    } else if (u2 != null) {
      if (u2 == usernameKey) {
        username = "You".tr;
      } else {
        username = "@$u2";
      }
    } else {
      username = "Unknown User".tr;
    }
    return Text(username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: shadowColor, fontWeight: FontWeight.w400, fontSize: textSM));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width * 0.82,
        margin: EdgeInsets.only(bottom: spaceXLG),
        transform: Matrix4.translationValues(40.0, 5.0, 0.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.35),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: spaceSM),
              margin: EdgeInsets.symmetric(vertical: spaceSM),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getProfileImage(
                            widget.content.acUsername,
                            widget.content.ucUsername,
                            widget.content.acImage,
                            widget.content.ucImage),
                        SizedBox(
                            width: widget.width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(ucAll(widget.content.attendanceTitle),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: darkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textXMD - 1)),
                                const SizedBox(height: 1),
                                getUsername(widget.content.acUsername,
                                    widget.content.ucUsername),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: spaceXSM),
                    getDescHeaderWidget(
                        widget.content.attendanceDesc, darkColor, 3)
                  ]),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: spaceSM),
              margin: EdgeInsets.symmetric(vertical: spaceSM),
              child: Wrap(
                  runSpacing: spaceWrap,
                  spacing: spaceWrap,
                  children: [getTotalAttendance(4, true)]),
            ),
            Container(
                transform: Matrix4.translationValues(0.0, 5.0, 0.0),
                padding: EdgeInsets.zero,
                width: widget.width,
                height: 35,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(primaryColor),
                  ),
                  child: Text('Submit', style: TextStyle(fontSize: textMD)),
                )),
          ],
        ));
  }
}

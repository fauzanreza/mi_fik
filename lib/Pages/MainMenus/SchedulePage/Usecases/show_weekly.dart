import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetWeeklyNavigator extends StatelessWidget {
  final DateTime active;
  final Function(int) action;

  const GetWeeklyNavigator({Key key, this.active, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 70,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            //Get day style.
            getBgcolor(i) {
              if (i == 0) {
                return primaryColor;
              } else {
                return whitebg;
              }
            }

            getcolor(i) {
              if (i == 0) {
                return whitebg;
              } else {
                return blackbg;
              }
            }

            if (index == 0 &&
                DateFormat("dd-MM-yyyy").format(slctSchedule) !=
                    DateFormat("dd-MM-yyyy").format(DateTime.now())) {
              return Row(children: [
                GestureDetector(
                    onTap: () {
                      if (selectedArchiveSlug != null) {
                        selectedArchiveSlug = null;
                        selectedArchiveName = null;
                      }
                      slctSchedule = DateTime.now();

                      Get.offAll(() => const BottomBar());
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: paddingXSM),
                      decoration: BoxDecoration(
                        color: dangerColor,
                        borderRadius: BorderRadius.all(roundedMd),
                        boxShadow: [getShadow("med")],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Today".tr,
                                style: TextStyle(
                                    color: getcolor(index),
                                    fontSize: textSM,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 5),
                            Container(
                                padding: const EdgeInsets.only(left: 3.5),
                                child: FaIcon(
                                  FontAwesomeIcons.rotateLeft,
                                  color: whitebg,
                                  size: iconMD * 1.25,
                                ))
                          ]),
                    )),
                GestureDetector(
                    onTap: () => action(index),
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: paddingXSM),
                      decoration: BoxDecoration(
                        color: getBgcolor(index),
                        borderRadius: BorderRadius.all(roundedMd),
                        boxShadow: [getShadow("med")],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                DateFormat("EEE")
                                    .format(active.add(Duration(days: index))),
                                style: TextStyle(
                                    color: getcolor(index),
                                    fontSize: textSM,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                (active.add(Duration(days: index)).day)
                                    .toString(),
                                style: TextStyle(
                                    color: getcolor(index),
                                    fontSize: textXLG,
                                    fontWeight: FontWeight.w500))
                          ]),
                    ))
              ]);
            } else {
              return GestureDetector(
                  onTap: () => action(index),
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: paddingXSM),
                    decoration: BoxDecoration(
                      color: getBgcolor(index),
                      borderRadius: BorderRadius.all(roundedMd),
                      boxShadow: [getShadow("med")],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              DateFormat("EEE")
                                  .format(active.add(Duration(days: index))),
                              style: TextStyle(
                                  color: getcolor(index),
                                  fontSize: textSM,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              (active.add(Duration(days: index)).day)
                                  .toString(),
                              style: TextStyle(
                                  color: getcolor(index),
                                  fontSize: textXLG,
                                  fontWeight: FontWeight.w500))
                        ]),
                  ));
            }
          }),
    );
  }
}

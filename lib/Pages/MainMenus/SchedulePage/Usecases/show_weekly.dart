import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
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
      padding: EdgeInsets.only(left: spaceSM),
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
                return whiteColor;
              }
            }

            getcolor(i) {
              if (i == 0) {
                return whiteColor;
              } else {
                return darkColor;
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

                      Get.offNamed(CollectionRoute.bar,
                          preventDuplicates: false);
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(right: spaceSM, bottom: spaceSM),
                      padding: EdgeInsets.symmetric(horizontal: spaceSM),
                      decoration: BoxDecoration(
                        color: warningBG,
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedSM)),
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
                                padding: EdgeInsets.only(left: spaceMini - 0.5),
                                child: FaIcon(
                                  FontAwesomeIcons.rotateLeft,
                                  color: whiteColor,
                                  size: iconMD,
                                ))
                          ]),
                    )),
                GestureDetector(
                    onTap: () => action(index),
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(right: spaceSM, bottom: spaceSM),
                      padding: EdgeInsets.symmetric(horizontal: spaceSM),
                      decoration: BoxDecoration(
                        color: getBgcolor(index),
                        borderRadius:
                            BorderRadius.all(Radius.circular(roundedSM)),
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
                                    fontSize: textLG,
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
                    margin: EdgeInsets.only(right: spaceSM, bottom: spaceSM),
                    padding: EdgeInsets.symmetric(horizontal: spaceSM),
                    decoration: BoxDecoration(
                      color: getBgcolor(index),
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundedSM)),
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
                                  fontSize: textLG,
                                  fontWeight: FontWeight.w500))
                        ]),
                  ));
            }
          }),
    );
  }
}

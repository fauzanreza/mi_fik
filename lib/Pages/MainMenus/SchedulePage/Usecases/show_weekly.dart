import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
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

            return GestureDetector(
                onTap: () => action(index),
                child: Container(
                  width: 58,
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
                        Text((active.add(Duration(days: index)).day).toString(),
                            style: TextStyle(
                                color: getcolor(index),
                                fontSize: textXLG,
                                fontWeight: FontWeight.w500))
                      ]),
                ));
          }),
    );
  }
}

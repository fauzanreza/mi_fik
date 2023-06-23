import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class FAQSkeleton extends StatelessWidget {
  const FAQSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                  alignment: Alignment.topLeft,
                  width: fullWidth,
                  padding: EdgeInsets.all(paddingSM - 2),
                  margin: EdgeInsets.only(
                      left: fullWidth * 0.2, right: paddingSM, top: paddingXSM),
                  child: SkeletonLine(
                      style: SkeletonLineStyle(
                          height: paddingLg * 2,
                          borderRadius: BorderRadius.all(roundedMd))));
            }));
  }
}

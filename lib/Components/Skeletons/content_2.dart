import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class ContentSkeleton2 extends StatelessWidget {
  const ContentSkeleton2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(spaceXSM),
            child: Container(
              padding: EdgeInsets.all(spaceXSM),
              margin:
                  EdgeInsets.only(left: spaceJumbo + spaceSM, right: spaceLG),
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
              child: SkeletonItem(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 15,
                            width: 120,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 15,
                            width: 64,
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                  SizedBox(height: spaceSM),
                  SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 2,
                        spacing: spaceWrap,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: textSM,
                          borderRadius: BorderRadius.circular(8),
                          minLength: fullWidth * 0.5,
                        )),
                  ),
                  SizedBox(height: spaceSM),
                ],
              )),
            ),
          ),
        ));
  }
}

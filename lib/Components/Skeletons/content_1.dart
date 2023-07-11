import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class ContentSkeleton1 extends StatelessWidget {
  const ContentSkeleton1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(spaceXSM),
            child: Container(
              padding: EdgeInsets.all(spaceXSM),
              margin: EdgeInsets.only(left: spaceJumbo),
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
                  const SkeletonAvatar(
                    style:
                        SkeletonAvatarStyle(width: double.infinity, height: 60),
                  ),
                  SizedBox(height: spaceSM),
                  SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 3,
                        spacing: spaceWrap,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: textSM,
                          borderRadius: BorderRadius.circular(8),
                          minLength: fullWidth / 2,
                        )),
                  ),
                  SizedBox(height: spaceSM),
                  const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: double.infinity,
                      height: 35,
                    ),
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}

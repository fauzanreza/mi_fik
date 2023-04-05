import 'package:flutter/material.dart';
import 'package:mi_fik/main.dart';
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
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(left: 35),
              decoration: BoxDecoration(
                color: whitebg,
                borderRadius: BorderRadius.all(roundedMd),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 128, 128, 128)
                        .withOpacity(0.3),
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
                  SizedBox(height: paddingXSM),
                  SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 3,
                        spacing: 6,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: textSM,
                          borderRadius: BorderRadius.circular(8),
                          minLength: fullWidth / 2,
                        )),
                  ),
                  SizedBox(height: paddingXSM),
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
import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class TagSkeleton1 extends StatelessWidget {
  const TagSkeleton1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    double len = 105;

    return SizedBox(
        width: fullWidth,
        child: Wrap(runSpacing: -spaceWrap, spacing: spaceWrap * 2, children: [
          Container(
            padding: EdgeInsets.all(spaceXSM),
            width: len * 0.8,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.25),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(
                    3.0,
                    3.0,
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
                    SkeletonAvatar(
                        style:
                            SkeletonAvatarStyle(width: textSM, height: textSM)),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: textXMD,
                          width: len * 0.45,
                          borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                ),
              ],
            )),
          ),
          Container(
            padding: EdgeInsets.all(spaceXSM),
            width: len * 1.2,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.25),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(
                    3.0,
                    3.0,
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
                    SkeletonAvatar(
                        style:
                            SkeletonAvatarStyle(width: textSM, height: textSM)),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: textXMD,
                          width: len * 0.85,
                          borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                ),
              ],
            )),
          ),
          Container(
            padding: EdgeInsets.all(spaceXSM),
            width: len,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(roundedSM)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.25),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(
                    3.0,
                    3.0,
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
                    SkeletonAvatar(
                        style:
                            SkeletonAvatarStyle(width: textSM, height: textSM)),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: textXMD,
                          width: len * 0.65,
                          borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                ),
              ],
            )),
          ),
        ]));
  }
}

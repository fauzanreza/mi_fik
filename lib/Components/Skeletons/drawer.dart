import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class DrawerSkeleton extends StatelessWidget {
  const DrawerSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Drawer(
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, semidarkColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: fullWidth,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: spaceSM),
                              child: SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      height: fullWidth * 0.15,
                                      width: fullWidth * 0.15,
                                      shape: BoxShape.circle))),
                          Container(
                            margin: EdgeInsets.only(bottom: spaceSM),
                            child: const SkeletonLine(
                              style: SkeletonLineStyle(
                                  width: 200, alignment: Alignment.center),
                            ),
                          ),
                          const SkeletonLine(
                            style: SkeletonLineStyle(
                                width: 200, alignment: Alignment.center),
                          )
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  SizedBox(height: fullHeight * 0.13),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: spaceSM),
                    child: SkeletonLine(
                      style:
                          SkeletonLineStyle(height: 40, width: fullWidth * 0.5),
                    ),
                  )
                ])));
  }
}

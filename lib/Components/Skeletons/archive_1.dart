import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

class ArchiveSkeleton1 extends StatelessWidget {
  const ArchiveSkeleton1({Key key}) : super(key: key);

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
              margin: EdgeInsets.symmetric(horizontal: spaceJumbo + spaceSM),
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
                  SizedBox(height: spaceLG * 0.75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 18,
                            width: 110,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 14,
                            width: 120,
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                  SizedBox(height: spaceLG * 0.75),
                ],
              )),
            ),
          ),
        ));
  }
}

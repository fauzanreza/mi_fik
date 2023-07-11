import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Firebases/Storages/validator.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:skeletons/skeletons.dart';

Widget getProfileImageSideBar(double width, double size, String url) {
  if (url != null && url != "null") {
    return Container(
      margin: EdgeInsets.all(spaceSM),
      // width: width * 0.3,
      // height: width * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(roundedCircle)),
          border: Border.all(color: whiteColor, width: spaceMini - 1)),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(roundedCircle)),
          child: FutureBuilder<bool>(
            future: isLoadable(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: width * size,
                      height: width * size,
                      shape: BoxShape.circle),
                );
              } else if (snapshot.hasData && snapshot.data == true) {
                return Image.network(
                  url,
                  width: width * size,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                  height: width * size,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: width * size,
                          height: width * size,
                          shape: BoxShape.circle),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icon/default_failed_profile.png',
                      width: width * size,
                      height: width * size,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    );
                  },
                );
              } else {
                return Image.asset(
                  'assets/icon/default_failed_profile.png',
                  width: width * size,
                  height: width * size,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                );
              }
            },
          )),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(spaceMini),
      margin: EdgeInsets.all(spaceSM),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(roundedCircle)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(roundedCircle)),
        child: Image.asset(
          'assets/icon/default_lecturer.png',
          width: width * size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
      ),
    );
  }
}

Widget getProfileImage(u1, u2, i1, i2) {
  String image;
  if (u1 != null) {
    if (i1 != null) {
      image = i1;
    } else {
      image = null;
    }
  } else if (u2 != null) {
    if (i2 != null) {
      image = i2;
    } else {
      image = null;
    }
  } else {
    image = null;
  }
  return getProfileImageContent(image);
}

Widget getProfileImageContent(var url) {
  if (url != null && url != "null") {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spaceSM),
      width: iconJumbo,
      height: iconJumbo,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(roundedXLG + roundedMini),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(roundedXLG + roundedMini),
        child: FutureBuilder<bool>(
          future: isLoadable(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: iconXL,
                  height: iconXL,
                ),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return Image.network(
                url,
                width: iconXL,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                height: iconXL,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: iconXL,
                      height: iconXL,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/icon/default_failed_profile.png',
                    width: iconXL,
                    height: iconXL,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  );
                },
              );
            } else {
              return Image.asset(
                'assets/icon/default_failed_profile.png',
                width: iconXL,
                height: iconXL,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              );
            }
          },
        ),
      ),
    );
  } else {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spaceSM),
      width: iconJumbo,
      height: iconJumbo,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(roundedXLG + roundedMini),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(roundedXLG + roundedMini),
        child: Image.asset('assets/icon/default_lecturer.png',
            filterQuality: FilterQuality.low, fit: BoxFit.cover),
      ),
    );
  }
}

Widget getMessageImageNoData(String url, String msg, double width) {
  return Column(children: [
    Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: spaceLG),
      width: width * 0.55,
      height: width * 0.55,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(width * 0.6)),
      ),
      child: ClipRRect(
        child: Image.asset(url, width: width * 0.45),
      ),
    ),
    getSubTitleMedium(msg, shadowColor, TextAlign.center)
  ]);
}

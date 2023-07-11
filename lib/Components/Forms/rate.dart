import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getInputRate(var action) {
  return Container(
    margin: EdgeInsets.all(spaceXMD),
    child: RatingBar.builder(
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: spaceMini),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: successBG,
      ),
      onRatingUpdate: action,
    ),
  );
}

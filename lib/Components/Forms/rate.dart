import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

Widget getInputRate(var action) {
  return Container(
    margin: EdgeInsets.all(paddingSM),
    child: RatingBar.builder(
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: successbg,
      ),
      onRatingUpdate: action,
    ),
  );
}

import 'package:flutter/material.dart';

// Navigation
String passSlugContent;
String passRoleGeneral;

// Selected
var selectedArchiveName;
var selectedArchiveId;
var locCoordinateCtrl;

final selectedTag = [];
final locDetailCtrl = TextEditingController();

List archieveVal = [];

int selectedIndex = 0;

// Starting Variables
String sortingHomepageContent = "Desc";

DateTime slctSchedule = DateTime.now();

// Class and object
class UserProfileLeftBar {
  final String username;
  final String image;
  final List<dynamic> roles;

  UserProfileLeftBar({this.username, this.image, this.roles});
}

class Role {
  var role;

  Role({this.role});
}

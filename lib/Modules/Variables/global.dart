import 'package:flutter/material.dart';

// Navigation
String passSlugContent;
// String passRoleGeneral;

// Selected
var selectedArchiveName;
var selectedArchiveDesc;
var locCoordinateCtrl;
var selectedArchiveSlug;
var selectedRole = [];

final selectedTag = [];
var slctQuestionType = "";
var slctFeedbackType = "";
final locDetailCtrl = TextEditingController();

List archieveVal = [];

int selectedIndex = 0;

// Starting Variables
String sortingHomepageContent = "Desc";

DateTime slctSchedule = DateTime.now();

// Filled by API dictionary
List<String> questionTypeOpt = [];
List<String> feedbackTypeOpt = [];

// Class and object
class UserProfileLeftBar {
  final String username;
  final String image;
  final String roleGeneral;

  UserProfileLeftBar({this.username, this.image, this.roleGeneral});
}

class Role {
  final String role;

  Role({this.role});
}

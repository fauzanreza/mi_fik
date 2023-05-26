import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Navigation
String passSlugContent;

// Others
String locName;
List listAttachment = [];
List<Map<String, dynamic>> listArchiveCheck = [];

// Selected
var selectedArchiveName;
var selectedArchiveDesc;
var locCoordinateCtrl;
var selectedArchiveSlug;
var selectedRole = [];

final selectedTag = [];
var slctQuestionType = "event";
var slctFeedbackType = "feedback_design";
var slctAttachmentType = "image";
var slctReminderType = "reminder_3_hour_before";

int selectedIndex = 0;

// Starting Variables
String sortingHomepageContent = "Desc";
String filteringTag = "all";
String searchingContent;
String contentAttImage;
DateTime filterDateStart;
DateTime filterDateEnd;
var selectedTagFilterContent = [];

DateTime slctSchedule = DateTime.now();

// Filled by API dictionary
List<String> questionTypeOpt = [];
List<String> feedbackTypeOpt = [];
List<String> attachmentTypeOpt = [];
List<String> reminderTypeOpt = [];

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

// Firebase FCM
bool shouldUseFirestoreEmulator = false;

String token;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

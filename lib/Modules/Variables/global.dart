import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

// Navigation
String passSlugContent;

// Others
String locName;
String usernameKey;
List listAttachment = [];
List<Map<String, dynamic>> listArchiveCheck = [];
TabController tabController;
bool isOffline = false;
FlashMode flashMode = FlashMode.off;

//Schedule Page
String archiveNameMsg = "";
String archiveDescMsg = "";
String allArchiveMsg = "";

// Selected
String selectedArchiveName;
String selectedArchiveDesc;
String locCoordinateCtrl;
String selectedArchiveSlug;

// Forget password
int indexForget = 0;
bool checkAvaiabilityForget = false;
bool isWaitingLoad = true;
bool isInvalidToken = false;
bool tokenValidated = false;

//Regis only
int indexRegis = 0;
bool isCheckedRegister = false;
bool isFillForm = false;
bool isChooseRole = false;
String uploadedImageRegis;
bool checkAvaiabilityRegis = false;
bool isFinishedRegis = false;
bool isWaiting = false;
bool successValidateAnimation = false;

String usernameAvaiabilityCheck = "";
String emailAvaiabilityCheck = "";

String passRegisCtrl = "";
int validRegisCtrl;
String fnameRegisCtrl = "";
String lnameRegisCtrl = "";

// Array selection
var selectedRole = [];
final selectedTag = [];

// Initial Dropdown
var slctQuestionType = "event";
var slctFeedbackType = "feedback_design";
var slctAttachmentType = "image";
var slctReminderType = "reminder_3_hour_before";
var slctValidUntil = "2023";

// Inital calendar and schedule page
DateTime slctSchedule = DateTime.now();
DateTime slctCalendar = DateTime.now();

// File upload max size
int maxImage = 4;
int maxVideo = 20;
int maxDoc = 15;

// Language
enum LangList { en, id }

LangList slctLang;

int selectedIndex = 0;

// Starting Variables
String sortingHomepageContent = "Desc";
String filteringTag = "all";
String searchingContent = "";
String contentAttImage;
DateTime filterDateStart;
DateTime filterDateEnd;
var selectedTagFilterContent = [];

// Filled by API dictionary
List<String> questionTypeOpt = [];
List<String> feedbackTypeOpt = [];
List<String> attachmentTypeOpt = [];
List<String> reminderTypeOpt = [];
List<String> validUntil = ["2023"];

// Class and object
class UserProfileLeftBar {
  final String username;
  final String image;
  final String roleGeneral;

  UserProfileLeftBar({this.username, this.image, this.roleGeneral});
}

class ProfileData {
  final String username;
  final String image;
  final String email;
  final String pass;
  final String fname;
  final String lname;

  ProfileData(
      {this.username,
      this.image,
      this.email,
      this.pass,
      this.fname,
      this.lname});
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

NotificationDetails fcmConfig = NotificationDetails(
  android: AndroidNotificationDetails(
    "${channel.id}2",
    channel.name,
    channelDescription: channel.description,
    color: primaryColor,
    enableLights: true,
    icon: "@mipmap/ic_launcher",
    priority: Priority.max,
    playSound: true,
    importance: Importance.max,
    sound: const RawResourceAndroidNotificationSound('notif_1'),
  ),
);

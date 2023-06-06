import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Navigation
String passSlugContent;

// Others
String locName;
List listAttachment = [];
List<Map<String, dynamic>> listArchiveCheck = [];

// Selected
String selectedArchiveName;
String selectedArchiveDesc;
String locCoordinateCtrl;
String selectedArchiveSlug;

//Regis only
int indexRegis = 0;
bool isCheckedRegister = false;
bool isFillForm = false;
bool isChooseRole = false;
String uploadedImageRegis;
bool checkAvaiabilityRegis = false;
bool isFinishedRegis = false;

String usernameAvaiabilityCheck = "";
String emailAvaiabilityCheck = "";

String passRegisCtrl;
int validRegisCtrl;
String fnameRegisCtrl;
String lnameRegisCtrl;

var selectedRole = [];

final selectedTag = [];
var slctQuestionType = "event";
var slctFeedbackType = "feedback_design";
var slctAttachmentType = "image";
var slctReminderType = "reminder_3_hour_before";
var slctValidUntil = "2023";
int maxImage = 4;
int maxVideo = 20;
int maxDoc = 15;

enum LangList { en, id }

LangList slctLang = LangList.en;

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
DateTime slctCalendar = DateTime.now();

// Filled by API dictionary
List<String> questionTypeOpt = [];
List<String> feedbackTypeOpt = [];
List<String> attachmentTypeOpt = [];
List<String> reminderTypeOpt = [];
List<String> validUntil = ["2019", "2020", "2021", "2022", "2023"];

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

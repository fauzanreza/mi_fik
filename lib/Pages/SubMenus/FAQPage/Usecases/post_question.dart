import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/index.dart';
import 'package:mi_fik/Pages/SubMenus/MyFAQPage/index.dart';

class PostQuestion extends StatefulWidget {
  const PostQuestion({Key key, this.from}) : super(key: key);
  final String from;

  @override
  StatePostQuestion createState() => StatePostQuestion();
}

class StatePostQuestion extends State<PostQuestion> {
  QuestionCommandsService apiService;
  String qbodyMsg = "";
  String qtypeMsg = "";
  String allMsg = "";

  final quBodyCtrl = TextEditingController();

  @override
  void dispose() {
    quBodyCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = QuestionCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return FloatingActionButton(
      onPressed: () async {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(roundedLG),
                  topRight: Radius.circular(roundedLG))),
          barrierColor: primaryColor.withOpacity(0.5),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Back',
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: spaceLG),
                        alignment: Alignment.centerLeft,
                        child:
                            getTitleLarge("Ask a question".tr, primaryColor)),
                    Container(
                      padding: EdgeInsets.only(left: spaceLG),
                      alignment: Alignment.centerLeft,
                      child: getSubTitleMedium(
                          "Question Body".tr, darkColor, TextAlign.start),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: spaceXMD),
                        child: getInputWarning(qbodyMsg)),
                    Container(
                        padding: EdgeInsets.fromLTRB(spaceXMD, 10, spaceXMD, 0),
                        child: getInputDesc(255, 5, quBodyCtrl, false)),
                    Container(
                      padding: EdgeInsets.only(left: spaceXMD),
                      child: Text("Question Type".tr,
                          style: TextStyle(
                            fontSize: textXMD - 1,
                            fontFamily: 'Poppins',
                            color: darkColor,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: spaceXMD),
                        child: getInputWarning(qtypeMsg)),
                    Container(
                        margin: EdgeInsets.only(bottom: spaceLG),
                        padding: EdgeInsets.only(left: spaceXMD),
                        child:
                            getDropDownMain(slctQuestionType, questionTypeOpt,
                                (String newValue) {
                          setState(() {
                            slctQuestionType = newValue;
                          });
                        }, false, null)),
                    Container(
                        padding: EdgeInsets.only(left: spaceXMD),
                        child: getInputWarning(allMsg)),
                    SizedBox(
                        width: fullWidth,
                        height: btnHeightMD,
                        child: ElevatedButton(
                          onPressed: () async {
                            AddQuestionModel data = AddQuestionModel(
                              quType: slctQuestionType,
                              quBody: quBodyCtrl.text.trim(),
                            );

                            //Validator
                            if (data.quType.isNotEmpty &&
                                data.quType.isNotEmpty) {
                              apiService.postUserReq(data).then((response) {
                                setState(() => isLoading = false);
                                var status = response[0]['message'];
                                var body = response[0]['body'];

                                if (status == "success") {
                                  if (widget.from == "myfaq") {
                                    Get.offAll(() => const MyFAQPage());
                                  } else {
                                    Get.offAll(() => const FAQPage());
                                  }

                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SuccessDialog(text: body));
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Get.back();
                                  });
                                  quBodyCtrl.clear();
                                } else {
                                  qbodyMsg = "";
                                  qtypeMsg = "";
                                  allMsg = "";

                                  Get.back();
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text: body, type: "faq"));
                                  setState(() {
                                    if (body is! String) {
                                      if (body['question_body'] != null) {
                                        qbodyMsg = body['question_body'][0];

                                        if (body['question_body'].length > 1) {
                                          for (String e
                                              in body['question_body']) {
                                            qbodyMsg += e;
                                          }
                                        }
                                      }

                                      if (body['question_type'] != null) {
                                        qtypeMsg = body['question_type'][0];

                                        if (body['question_type'].length > 1) {
                                          for (String e
                                              in body['question_type']) {
                                            qtypeMsg += e;
                                          }
                                        }
                                      }
                                    } else {
                                      allMsg = body;
                                    }
                                  });
                                }
                              });
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const FailedDialog(
                                          text:
                                              "Request failed, you haven't chosen any type yet",
                                          type: "faq"));
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(successBG),
                          ),
                          child: Text('Done'.tr),
                        ))
                  ],
                ));
          },
        );
      },
      backgroundColor: successBG,
      tooltip: "Ask a question".tr,
      child: const Icon(Icons.headset_mic),
    );
  }
}

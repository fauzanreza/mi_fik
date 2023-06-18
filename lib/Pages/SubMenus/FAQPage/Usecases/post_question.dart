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
              borderRadius:
                  BorderRadius.only(topLeft: roundedLG, topRight: roundedLG)),
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
                        padding: EdgeInsets.only(left: paddingMD),
                        alignment: Alignment.centerLeft,
                        child:
                            getTitleLarge("Ask a question".tr, primaryColor)),
                    Container(
                      padding: EdgeInsets.only(left: paddingMD),
                      alignment: Alignment.centerLeft,
                      child: getSubTitleMedium(
                          "Question Body".tr, blackbg, TextAlign.start),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: paddingSM),
                        child: getInputWarning(qbodyMsg)),
                    Container(
                        padding:
                            EdgeInsets.fromLTRB(paddingSM, 10, paddingSM, 0),
                        child: getInputDesc(255, 5, quBodyCtrl, false)),
                    Container(
                      padding: EdgeInsets.only(left: paddingSM),
                      child: Text("Question Type".tr,
                          style: TextStyle(
                            fontSize: textMD - 1,
                            fontFamily: 'Poppins',
                            color: blackbg,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: paddingSM),
                        child: getInputWarning(qtypeMsg)),
                    Container(
                        margin: EdgeInsets.only(bottom: paddingMD),
                        padding: EdgeInsets.only(left: paddingSM),
                        child:
                            getDropDownMain(slctQuestionType, questionTypeOpt,
                                (String newValue) {
                          setState(() {
                            slctQuestionType = newValue;
                          });
                        }, false, null)),
                    Container(
                        padding: EdgeInsets.only(left: paddingSM),
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
                                MaterialStatePropertyAll<Color>(successbg),
                          ),
                          child: Text('Done'.tr),
                        ))
                  ],
                ));
          },
        );
      },
      backgroundColor: successbg,
      tooltip: "Ask a question".tr,
      child: const Icon(Icons.headset_mic),
    );
  }
}

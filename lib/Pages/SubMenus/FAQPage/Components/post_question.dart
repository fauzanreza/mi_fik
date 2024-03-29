import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

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
                child: getTitleLarge("Ask a question".tr, primaryColor)),
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
              padding: EdgeInsets.only(left: spaceLG),
              alignment: Alignment.centerLeft,
              child: getSubTitleMedium(
                  "Question Type".tr, darkColor, TextAlign.start),
            ),
            Container(
                padding: EdgeInsets.only(left: spaceXMD),
                child: getInputWarning(qtypeMsg)),
            Container(
                margin: EdgeInsets.only(bottom: spaceLG),
                padding: EdgeInsets.only(left: spaceXMD),
                child: getDropDownMain(slctQuestionType, questionTypeOpt,
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
                    if (data.quType.isNotEmpty && data.quType.isNotEmpty) {
                      apiService.postUserReq(data).then((response) {
                        setState(() => {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          if (widget.from == "myfaq") {
                            Get.toNamed(CollectionRoute.myfaq,
                                preventDuplicates: false);
                          } else {
                            Get.toNamed(CollectionRoute.faq,
                                preventDuplicates: false);
                          }

                          Get.dialog(SuccessDialog(text: body));

                          quBodyCtrl.clear();
                        } else {
                          qbodyMsg = "";
                          qtypeMsg = "";
                          allMsg = "";

                          Get.back();
                          Get.dialog(FailedDialog(text: body, type: "faq"));
                          setState(() {
                            if (body is! String) {
                              if (body['question_body'] != null) {
                                qbodyMsg = body['question_body'][0];

                                if (body['question_body'].length > 1) {
                                  for (String e in body['question_body']) {
                                    qbodyMsg += e;
                                  }
                                }
                              }

                              if (body['question_type'] != null) {
                                qtypeMsg = body['question_type'][0];

                                if (body['question_type'].length > 1) {
                                  for (String e in body['question_type']) {
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
                      Get.dialog(const FailedDialog(
                          text:
                              "Request failed, you haven't chosen any type yet",
                          type: "faq"));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(successBG),
                  ),
                  child: Text('Done'.tr),
                ))
          ],
        ));
  }
}

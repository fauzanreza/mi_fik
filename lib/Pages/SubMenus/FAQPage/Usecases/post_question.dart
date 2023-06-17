import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/QuestionApi/Services/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/FAQPage/index.dart';

class PostQuestion extends StatefulWidget {
  const PostQuestion({Key key}) : super(key: key);

  @override
  _PostQuestion createState() => _PostQuestion();
}

class _PostQuestion extends State<PostQuestion> {
  QuestionCommandsService apiService;

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
                        margin: EdgeInsets.only(bottom: paddingMD),
                        padding: EdgeInsets.only(left: paddingSM),
                        child:
                            getDropDownMain(slctQuestionType, questionTypeOpt,
                                (String newValue) {
                          setState(() {
                            slctQuestionType = newValue;
                          });
                        }, false, null)),
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
                                  Get.to(() => const FAQPage());

                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SuccessDialog(text: body));
                                } else {
                                  Get.to(() => const FAQPage());

                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FailedDialog(
                                              text: body, type: "req"));
                                }
                              });
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => FailedDialog(
                                      text:
                                          "Request failed, you haven't chosen any tag yet",
                                      type: "req"));
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

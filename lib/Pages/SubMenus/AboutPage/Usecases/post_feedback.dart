import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Forms/rate.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/FeedbackApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/FeedbackApi/Services/commands.dart';
import 'package:mi_fik/Modules/Helpers/info.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/index.dart';

class PostFeedback extends StatefulWidget {
  const PostFeedback({Key key}) : super(key: key);

  @override
  StatePostFeedback createState() => StatePostFeedback();
}

class StatePostFeedback extends State<PostFeedback> {
  FeedbackCommandsService apiService;
  final fbBodyCtrl = TextEditingController();
  int rateCtrl;

  @override
  void dispose() {
    fbBodyCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = FeedbackCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(spaceLG),
        margin: EdgeInsets.all(spaceXMD),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whiteColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSubTitleMedium("Let us know, what do you think about this App?",
                darkColor, TextAlign.start),
            getInputRate((double rate) {
              setState(() {
                rateCtrl = rate.toInt();
              });
            }),
            getInputDesc(255, 3, fbBodyCtrl, false),
            SizedBox(height: spaceLG),
            const GetInfoBox(
              page: "landing",
              location: "add_feedback",
            ),
            SizedBox(height: spaceXMD),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("What do you think the improvment should be".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: darkColor,
                      fontWeight: FontWeight.w500,
                    ))),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: spaceSM),
                      child: getDropDownMain(slctFeedbackType, feedbackTypeOpt,
                          (String newValue) {
                        setState(() {
                          slctFeedbackType = newValue;
                        });
                      }, true, "feedback_")),
                  const Spacer(),
                  InkWell(
                      onTap: () async {
                        FeedbackModel data = FeedbackModel(
                            fbBody: fbBodyCtrl.text.trim(),
                            rate: rateCtrl,
                            suggest: slctFeedbackType);

                        //Validator
                        if (data.fbBody != null ||
                            (data.rate >= 0 && data.rate <= 5)) {
                          apiService.postFeedback(data).then((response) {
                            setState(() => {});
                            var status = response[0]['message'];
                            var body = response[0]['body'];

                            if (status == "success") {
                              fbBodyCtrl.clear();
                              Get.to(() => const AboutPage());

                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SuccessDialog(text: body));
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FailedDialog(
                                          text: body, type: "addfeedback"));
                            }
                          });
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const FailedDialog(
                                      text:
                                          "Add feedback, field can't be empty",
                                      type: "addfeedback"));
                        }
                      },
                      child: Container(
                        width: 110,
                        padding: EdgeInsets.symmetric(
                            vertical: spaceSM, horizontal: spaceSM + 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: whiteColor, width: 2),
                            color: successBG,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            Icon(Icons.send,
                                size: iconSM + 3, color: whiteColor),
                            const Spacer(),
                            Text("Submit".tr,
                                style: TextStyle(
                                    fontSize: textXMD,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor))
                          ],
                        ),
                      )),
                ])
          ],
        ));
  }
}

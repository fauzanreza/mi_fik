import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Forms/rate.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/FeedbackApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/FeedbackApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/AboutPage/index.dart';

class PostFeedback extends StatefulWidget {
  const PostFeedback({Key key}) : super(key: key);

  @override
  _PostFeedback createState() => _PostFeedback();
}

class _PostFeedback extends State<PostFeedback> {
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
    bool isLoading = false;

    return Container(
        padding: EdgeInsets.all(paddingMD),
        margin: EdgeInsets.all(paddingSM),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: whitebg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSubTitleMedium(
                "Let us know, what do you think about this App?", blackbg),
            getInputRate((double rate) {
              setState(() {
                rateCtrl = rate.toInt();
              });
            }),
            getInputDesc(255, 3, fbBodyCtrl, false),
            Row(children: [
              Container(
                  margin: EdgeInsets.only(bottom: paddingMD),
                  padding: EdgeInsets.only(left: paddingSM),
                  child: getDropDownMain(slctFeedbackType, feedbackTypeOpt,
                      (String newValue) {
                    setState(() {
                      slctFeedbackType = newValue;
                    });
                  }, true, "feedback_")),
              // Info or help
            ]),
            InkWell(
              onTap: () async {
                FeedbackModel data = FeedbackModel(
                    fbBody: fbBodyCtrl.text,
                    rate: rateCtrl,
                    suggest: slctFeedbackType);

                //Validator
                if (data.fbBody != null || (data.rate >= 0 && data.rate <= 5)) {
                  apiService.postFeedback(data).then((response) {
                    setState(() => isLoading = false);
                    var status = response[0]['message'];
                    var body = response[0]['body'];

                    if (status == "success") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                      );
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              SuccessDialog(text: body));
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              FailedDialog(text: body, type: "addfeedback"));
                    }
                  });
                } else {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => FailedDialog(
                          text: "Add feedback, field can't be empty",
                          type: "addfeedback"));
                }
              },
              child: Container(
                width: 110,
                margin: EdgeInsets.only(top: paddingXSM),
                padding: EdgeInsets.symmetric(
                    vertical: paddingXSM, horizontal: paddingXSM + 3),
                decoration: BoxDecoration(
                    border: Border.all(color: whitebg, width: 2),
                    color: successbg,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Icon(Icons.send, size: iconSM + 3, color: whitebg),
                    const Spacer(),
                    Text("Submit",
                        style: TextStyle(
                            fontSize: textMD,
                            fontWeight: FontWeight.w500,
                            color: whitebg))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

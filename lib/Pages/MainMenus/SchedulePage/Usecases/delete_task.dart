import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_tasks.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DeleteTask extends StatefulWidget {
  const DeleteTask({Key key, this.id, this.name}) : super(key: key);
  final String id;
  final String name;

  @override
  StateDeleteTask createState() => StateDeleteTask();
}

class StateDeleteTask extends State<DeleteTask> {
  TaskCommandsService taskService;

  @override
  void initState() {
    super.initState();
    taskService = TaskCommandsService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        height: 120,
        width: fullWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Are you sure want to delete this '${widget.name}' task",
                  style: TextStyle(
                      color: darkColor,
                      fontSize: textXMD,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 15),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: warningBG.withOpacity(0.8),
                        padding: EdgeInsets.all(spaceLG * 0.8)),
                    onPressed: () async {
                      taskService.deleteTask(widget.id).then((response) {
                        setState(() => {});
                        var status = response[0]['message'];
                        var body = response[0]['body'];

                        if (status == "success") {
                          Get.offAll(() => const BottomBar());

                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  SuccessDialog(text: body));
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FailedDialog(text: body, type: "deletetask"));
                        }
                      });
                    },
                    child: Text(
                      "Yes, Delete task".tr,
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.all(spaceLG * 0.8)),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel".tr,
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              )
            ]));
  }
}

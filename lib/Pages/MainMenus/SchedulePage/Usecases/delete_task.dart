import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Dialogs/failed_dialog.dart';
import 'package:mi_fik/Components/Dialogs/success_dialog.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/command_tasks.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class DeleteTask extends StatefulWidget {
  DeleteTask({Key key, this.id, this.name}) : super(key: key);
  String id;
  String name;

  @override
  _DeleteTask createState() => _DeleteTask();
}

class _DeleteTask extends State<DeleteTask> {
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
    bool isLoading = false;

    return SizedBox(
        height: 120,
        width: fullWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Are you sure want to delete this '${widget.name}' task",
                  style: TextStyle(
                      color: blackbg,
                      fontSize: textMD,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 15),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: dangerColor.withOpacity(0.8),
                        padding: EdgeInsets.all(paddingMD * 0.8)),
                    onPressed: () async {
                      taskService.deleteTask(widget.id).then((response) {
                        setState(() => isLoading = false);
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
                        color: whitebg,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.all(paddingMD * 0.8)),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel".tr,
                      style: TextStyle(
                        color: whitebg,
                      ),
                    ),
                  )
                ],
              )
            ]));
  }
}
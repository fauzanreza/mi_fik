import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/DB/Model/Archieve_M.dart';
import 'package:mi_fik/Others/checkbox.dart';
import 'package:mi_fik/main.dart';

class SaveButton extends StatefulWidget {
  SaveButton({Key key, this.passId}) : super(key: key);
  int passId;

  @override
  _SaveButton createState() => _SaveButton();
}

class _SaveButton extends State<SaveButton> {
  //Initial variable
  var db = Mysql();
  final List<ArchieveModel> _archieveList = <ArchieveModel>[];

  //Controller
  Future getArchieve() async {
    db.getConnection().then((conn) {
      String sql =
          "SELECT archieve.archieve_name,  CASE WHEN content.content_type = 'event' THEN COUNT(content.id) ELSE 0 END AS event, CASE WHEN content.content_type = 'task' THEN COUNT(content.id) ELSE 0 END AS task FROM archieve JOIN archieve_relation ON archieve.id = archieve_relation.archieve_id join content on content.id = archieve_relation.content_id WHERE archieve.id_user = 1 GROUP by archieve.id ORDER BY archieve.created_at";
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //Mapping
            var archieveModels = ArchieveModel();

            archieveModels.id = row['id'];
            archieveModels.archieveName = row['archieve_name'];
            archieveModels.event = row['event'];
            archieveModels.task = row['task'];

            _archieveList.add(archieveModels);
          });
        }
      });
      conn.close();
    });
  }

  Future postArchieveRel(archieveId, contentId) async {
    var date = DateFormat("yyyy-MM-dd h:i:s").format(DateTime.now()).toString();

    db.getConnection().then((conn) {
      String sql =
          "INSERT INTO `archieve_relation`(`id`, `archieve_id`, `content_id`, `user_id`, `created_at`, `updated_at`) VALUES (null,'${archieveId}','${contentId}',1, '${date}','${date}')";
      conn.query(sql).then((results) {
        print("success");
      });
      conn.close();
    });
  }

  //Get total content in an archieve
  getTotalArchieve(event, task) {
    if ((event != 0) && (task == 0)) {
      return "${event} Events";
    } else if ((event == 0) && (task != 0)) {
      return "${task} Task";
    } else {
      return "${event} Events, ${task} Task";
    }
  }

  @override
  void initState() {
    super.initState();
    getArchieve();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return //Full save button.
        SizedBox(
            width: fullWidth,
            height: btnHeightMD,
            child: ElevatedButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      elevation: 0, //Remove shadow.
                      backgroundColor: Colors.transparent,
                      content: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: fullWidth * 1,
                                width: fullWidth,
                                padding: EdgeInsets.all(paddingMD),
                                decoration: BoxDecoration(
                                    color: whitebg,
                                    borderRadius: BorderRadius.all(roundedMd)),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _archieveList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: fullWidth,
                                        height:
                                            btnHeightMD, //Same height as button.
                                        margin: EdgeInsets.symmetric(
                                            vertical: marginHZ),
                                        padding: EdgeInsets.all(marginMT),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(roundedMd2),
                                        ),
                                        child: Row(children: [
                                          SizedBox(
                                            width: fullWidth * 0.35,
                                            child: Text(
                                                _archieveList[index]
                                                    .archieveName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: whitebg,
                                                    fontSize: textSM,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          const Spacer(),
                                          //This text is to small and will affect the name of archieve.
                                          Text(
                                              getTotalArchieve(
                                                  _archieveList[index].event,
                                                  _archieveList[index].task),
                                              style: TextStyle(
                                                color: whitebg,
                                                fontSize: textXXSM,
                                              )),
                                          const Spacer(),
                                          MyStatefulWidget(
                                              idArchieve:
                                                  _archieveList[index].id,
                                              idContent: widget.passId),
                                        ]),
                                      );
                                    })),
                            const SizedBox(height: 20),
                            Container(
                                width: fullWidth,
                                height: btnHeightMD,
                                margin: EdgeInsets.only(
                                    left: marginMT,
                                    right: marginMT,
                                    bottom: btnHeightMD),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //print(archieve.length.toString());
                                    for (int i = 0; i < archieve.length; i++) {
                                      //print("Data");
                                      archieve.forEach((element) {
                                        postArchieveRel(element.idContent,
                                            element.idArchieve);
                                      });
                                    }
                                    archieve.clear();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(roundedLG2),
                                    )),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            primaryColor),
                                  ),
                                  child: Text('Save',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: textMD)),
                                ))
                          ]))),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
              ),
              child: const Text('Save Event'),
            ));

    //Normal save button.
    // Container(
    //     width: fullWidth,
    //     margin: EdgeInsets.symmetric(horizontal: marginMT),
    //     child: ElevatedButton(
    //       onPressed: () {
    //         // Respond to button press
    //       },
    //       style: ButtonStyle(
    //         shape:
    //             MaterialStateProperty.all<RoundedRectangleBorder>(
    //                 RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(roundedLG2),
    //         )),
    //         backgroundColor:
    //             MaterialStatePropertyAll<Color>(primaryColor),
    //       ),
    //       child: const Text('Save Event'),
    //     ));
  }
}

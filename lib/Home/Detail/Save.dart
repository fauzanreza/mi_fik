import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/DB/Services/ArchieveServices.dart';
import 'package:mi_fik/Others/checkbox.dart';
import 'package:mi_fik/main.dart';

class SaveButton extends StatefulWidget {
  SaveButton({Key key, this.passId}) : super(key: key);
  int passId;

  @override
  _SaveButton createState() => _SaveButton();
}

class _SaveButton extends State<SaveButton> {
  ArchieveService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ArchieveService();
  }

  // Future postArchieveRel(archieveId) async {
  //   var date = DateFormat("yyyy-MM-dd h:i:s").format(DateTime.now()).toString();

  //   db.getConnection().then((conn) {
  //     String sql =
  //         "INSERT INTO `archieve_relation`(`id`, `archieve_id`, `content_id`, `user_id`, `created_at`, `updated_at`) VALUES (null,'${archieveId}','${widget.passId}',1, '${date}','${date}')";
  //     conn.query(sql).then((results) {
  //       print("success");
  //     });
  //     conn.close();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllArchieve(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ArchieveModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ArchieveModel> archieves = snapshot.data;
            return _buildListView(archieves);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ArchieveModel> archieves) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

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

    return //Full save button.
        SizedBox(
            width: fullWidth,
            height: btnHeightMD,
            child: ElevatedButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  barrierColor: primaryColor.withOpacity(0.5),
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
                                    itemCount: archieves.length,
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
                                                archieves[index]
                                                    .archieveName
                                                    .toString(),
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
                                                  archieves[index].event,
                                                  archieves[index].task),
                                              style: TextStyle(
                                                color: whitebg,
                                                fontSize: textXXSM,
                                              )),
                                          const Spacer(),
                                          MyStatefulWidget(
                                              idArchieve: archieves[index].id,
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
                                    //Insert multiple archive relation.
                                    for (int i = 0;
                                        i < archieveVal.length;
                                        i++) {
                                      // postArchieveRel(archieveVal[i]);
                                    }
                                    archieveVal.clear();
                                    Navigator.pop(context);
                                    showDialog<String>(
                                        barrierDismissible: true,
                                        barrierColor:
                                            primaryColor.withOpacity(0.5),
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                elevation: 0, //Remove shadow.
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: fullWidth * 0.45,
                                                        padding: EdgeInsets.all(
                                                            fullWidth * 0.1),
                                                        margin: EdgeInsets.only(
                                                            bottom: marginMT),
                                                        child: ClipRRect(
                                                          child: Image.asset(
                                                              'assets/icon/checklist.png'),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: whitebg,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      Text("Post Saved",
                                                          style: TextStyle(
                                                              color: whitebg,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: textLG))
                                                    ])));
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

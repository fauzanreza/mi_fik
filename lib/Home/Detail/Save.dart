import 'package:flutter/material.dart';
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
      String sql = 'SELECT * FROM archieve ORDER BY created_at DESC';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //Mapping
            var archieveModels = ArchieveModel();

            archieveModels.id = row['id'];
            archieveModels.archieveName = row['archieve_name'];

            _archieveList.add(archieveModels);
          });
        }
      });
      conn.close();
    });
  }

  @override
  void initState() {
    super.initState();
    getArchieve();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return //Full save button.
        SizedBox(
            width: fullWidth,
            height: btnHeightMD,
            child: ElevatedButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      contentPadding: EdgeInsets.all(paddingMD),
                      content: SizedBox(
                          height: fullWidth * 1,
                          width: fullWidth,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _archieveList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: fullWidth,
                                  margin:
                                      EdgeInsets.symmetric(vertical: marginHZ),
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
                                          _archieveList[index].archieveName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: whitebg,
                                              fontSize: textSM,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    const Spacer(),
                                    //This text is to small and will affect the name of archieve.
                                    Text("4 Events, 1 Task",
                                        style: TextStyle(
                                          color: whitebg,
                                          fontSize: textXXSM,
                                        )),
                                    Spacer(),
                                    MyStatefulWidget(),
                                  ]),
                                );
                              })))),
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

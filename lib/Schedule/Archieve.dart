import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Database.dart';
import 'package:mi_fik/DB/Model/Archieve_M.dart';
import 'package:mi_fik/main.dart';

class ArchievePage extends StatefulWidget {
  const ArchievePage({Key key}) : super(key: key);

  @override
  _ArchievePage createState() => _ArchievePage();
}

class _ArchievePage extends State<ArchievePage> {
  //Initial variable
  var db = Mysql();
  final List<ArchieveModel> _archieveList = <ArchieveModel>[];

  //Controller
  Future getArchieve() async {
    db.getConnection().then((conn) {
      String sql =
          "SELECT archieve.id, archieve.archieve_name,  CASE WHEN content.content_type = 'event' THEN COUNT(content.id) ELSE 0 END AS event, CASE WHEN content.content_type = 'task' THEN COUNT(content.id) ELSE 0 END AS task FROM archieve JOIN archieve_relation ON archieve.id = archieve_relation.archieve_id join content on content.id = archieve_relation.content_id WHERE archieve.id_user = 1 GROUP by archieve.id ORDER BY archieve.created_at";
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
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: _archieveList.map((content) {
      return SizedBox(
          width: fullWidth,
          child: IntrinsicHeight(
              child: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.05),
              width: 2.5,
              color: primaryColor,
            ),

            //Open content w/ full container
            GestureDetector(
                onTap: () {},
                child: Container(
                    height: 60,
                    width: fullWidth * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: paddingSM),
                    margin: EdgeInsets.only(top: marginMT),
                    transform: Matrix4.translationValues(55.0, 5.0, 0.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(roundedMd),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 128, 128, 128)
                              .withOpacity(0.3),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                        )
                      ],
                    ),
                    child: Row(children: [
                      SizedBox(
                        width: fullWidth * 0.35,
                        child: Text(content.archieveName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: whitebg,
                                fontSize: textSM,
                                fontWeight: FontWeight.w500)),
                      ),
                      const Spacer(),
                      //This text is to small and will affect the name of archieve.
                      Text(getTotalArchieve(content.event, content.task),
                          style: TextStyle(
                            color: whitebg,
                            fontSize: textXSM,
                          )),
                    ])))
          ])));
    }).toList());
  }
}

import 'package:flutter/material.dart';
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/DB/Services/ArchieveServices.dart';
import 'package:mi_fik/Others/skeleton/archive_1.dart';
import 'package:mi_fik/main.dart';

class ArchievePage extends StatefulWidget {
  const ArchievePage({Key key}) : super(key: key);

  @override
  _ArchievePage createState() => _ArchievePage();
}

class _ArchievePage extends State<ArchievePage> {
  ArchieveService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ArchieveService();
  }

  @override
  Widget build(BuildContext context) {
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
            return ArchiveSkeleton1();
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

    return Column(
        children: archieves.map((archieve) {
      return SizedBox(
          width: fullWidth,
          child: IntrinsicHeight(
              child: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.05),
              width: 2.5,
              color: primaryColor,
            ),

            //Open Archieve w/ full container
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
                        child: Text(archieve.archieveName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: whitebg,
                                fontSize: textSM,
                                fontWeight: FontWeight.w500)),
                      ),
                      const Spacer(),
                      //This text is to small and will affect the name of archieve.
                      Text(getTotalArchieve(archieve.event, archieve.task),
                          style: TextStyle(
                            color: whitebg,
                            fontSize: textXSM,
                          )),
                    ])))
          ])));
    }).toList());
  }
}

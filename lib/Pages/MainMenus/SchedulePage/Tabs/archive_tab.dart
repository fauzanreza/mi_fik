import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Bars/bottom_bar.dart';
import 'package:mi_fik/Components/Skeletons/archive_1.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key key}) : super(key: key);

  @override
  _ArchivePage createState() => _ArchivePage();
}

class _ArchivePage extends State<ArchivePage> {
  ArchiveQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ArchiveQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getMyArchive("%20"),
        builder:
            (BuildContext context, AsyncSnapshot<List<ArchiveModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ArchiveModel> archives = snapshot.data;
            return _buildListView(archives);
          } else {
            return const ArchiveSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ArchiveModel> archives) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getData(List<ArchiveModel> contents) {
      if (contents != null) {
        return Column(
            children: contents.map((archive) {
          return SizedBox(
              width: fullWidth,
              child: IntrinsicHeight(
                  child: Stack(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.05),
                  width: 2.5,
                  color: primaryColor,
                ),

                //Open Archive w/ full container
                GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedArchiveName = archive.archiveName;
                        selectedArchiveDesc = archive.archiveDesc;
                        selectedArchiveSlug = archive.slug;
                      });
                      Get.offAll(const BottomBar());
                    },
                    child: Container(
                        width: fullWidth * 0.7,
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingSM, vertical: paddingMD),
                        margin: EdgeInsets.only(top: marginMT),
                        transform: Matrix4.translationValues(55.0, 5.0, 0.0),
                        decoration: BoxDecoration(
                          color: whitebg,
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(archive.archiveName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: blackbg,
                                      fontSize: textSM,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: paddingXSM),
                              Text(
                                  getTotalArchive(
                                      archive.totalEvent, archive.totalTask),
                                  style: TextStyle(
                                    color: blackbg,
                                    fontSize: textXSM,
                                  )),
                            ])))
              ])));
        }).toList());
      } else {
        return SizedBox(
            height: fullHeight * 0.7,
            child: getMessageImageNoData("assets/icon/nodata2.png",
                "You haven't created any Archive", fullWidth));
      }
    }

    return getData(archives);
  }
}

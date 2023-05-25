import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';

import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_list_archive.dart';

class PostArchiveRelation extends StatefulWidget {
  PostArchiveRelation({Key key, this.passSlug}) : super(key: key);
  String passSlug;

  @override
  _PostArchiveRelation createState() => _PostArchiveRelation();
}

class _PostArchiveRelation extends State<PostArchiveRelation> {
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
        future: apiService.getMyArchive(widget.passSlug),
        builder:
            (BuildContext context, AsyncSnapshot<List<ArchiveModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ArchiveModel> archieves = snapshot.data;
            archieves.forEach((e) {
              listArchiveCheck.add({"slug": e.slug, "check": e.found});
            });
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

  Widget _buildListView(List<ArchiveModel> archieves) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Container(
        width: fullWidth * 0.9,
        height: btnHeightMD,
        margin:
            EdgeInsets.symmetric(horizontal: paddingSM, vertical: paddingXSM),
        child: ElevatedButton(
          onPressed: () => showDialog<String>(
              context: context,
              barrierColor: primaryColor.withOpacity(0.5),
              builder: (BuildContext context) =>
                  ListArchive(archieves: archieves)),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
          ),
          child: const Text('Save Event'),
        ));
  }
}

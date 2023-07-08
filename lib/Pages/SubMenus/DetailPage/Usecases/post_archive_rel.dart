import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';

import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/Usecases/get_list_archive.dart';

class PostArchiveRelation extends StatefulWidget {
  const PostArchiveRelation({Key key, this.passSlug, this.margin, this.ctx})
      : super(key: key);
  final String passSlug;
  final String ctx;
  final margin;

  @override
  StatePostArchiveRelation createState() => StatePostArchiveRelation();
}

class StatePostArchiveRelation extends State<PostArchiveRelation> {
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
        future: apiService.getMyArchive(widget.passSlug, widget.ctx),
        builder:
            (BuildContext context, AsyncSnapshot<List<ArchiveModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ArchiveModel> archieves = snapshot.data;
            listArchiveCheck = [];
            for (var e in archieves) {
              listArchiveCheck.add({"slug_name": e.slug, "check": e.found});
            }
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
        margin: widget.margin,
        child: ElevatedButton(
          onPressed: () => showDialog<String>(
              context: context,
              barrierColor: primaryColor.withOpacity(0.5),
              builder: (BuildContext context) => ListArchive(
                  archieves: archieves,
                  passSlug: widget.passSlug,
                  type: widget.ctx)),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(successBG),
          ),
          child: Text('Save ${widget.ctx}'.tr),
        ));
  }
}

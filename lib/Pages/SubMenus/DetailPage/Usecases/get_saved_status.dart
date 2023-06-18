import 'package:flutter/material.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ArchiveApi/Services/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetSavedStatus extends StatefulWidget {
  const GetSavedStatus({Key key, this.passSlug, this.ctx}) : super(key: key);
  final String passSlug;
  final String ctx;

  @override
  StateGetSavedStatus createState() => StateGetSavedStatus();
}

class StateGetSavedStatus extends State<GetSavedStatus> {
  ArchiveQueriesService apiService;
  bool found = false;

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

            for (var e in archieves) {
              if (e.found == 1) {
                found = true;
                break;
              }
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
    //double fullWidth = MediaQuery.of(context).size.width;

    if (found) {
      return Container(
        padding:
            EdgeInsets.symmetric(vertical: paddingXSM, horizontal: paddingSM),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 128, 128, 128).withOpacity(0.3),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
            color: successbg,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: RichText(
            text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(Icons.check, color: whitebg, size: iconMD),
            ),
            TextSpan(
                text: " Saved",
                style: TextStyle(
                    color: whitebg,
                    fontWeight: FontWeight.w500,
                    fontSize: textSM + 1)),
          ],
        )),
      );
    } else {
      return const SizedBox();
    }
  }
}

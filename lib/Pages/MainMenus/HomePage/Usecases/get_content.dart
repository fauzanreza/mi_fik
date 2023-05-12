import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Backgrounds/image.dart';
import 'package:mi_fik/Components/Container/content.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Services/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/MainMenus/HomePage/Usecases/set_control.dart';
import 'package:mi_fik/Pages/SubMenus/DetailPage/index.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key}) : super(key: key);

  @override
  _GetContent createState() => _GetContent();
}

class _GetContent extends State<GetContent> with TickerProviderStateMixin {
  ContentQueriesService apiService;
  //Initial variable
  final titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ContentQueriesService();
  }

  // void updateSorting(String newValue) {
  //   setState(() {
  //     sortingHomepageContent = newValue;
  //   });
  // }

  void updateDateStart(DateTime newValue) {
    setState(() {
      filterDateStart = newValue;
    });
  }

  void updateDateEnd(DateTime newValue) {
    setState(() {
      filterDateEnd = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllContentHeader(
            "all",
            sortingHomepageContent,
            getWhereDateFilter(filterDateStart, filterDateEnd),
            getFindFilter(searchingContent),
            1),
        builder: (BuildContext context,
            AsyncSnapshot<List<ContentHeaderModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentHeaderModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentHeaderModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    Widget getData(List<ContentHeaderModel> contents) {
      if (contents != null) {
        return Container(
            constraints: BoxConstraints(minHeight: fullHeight * 0.8),
            child: Column(
                children: contents.map((content) {
              return SizedBox(
                  width: fullWidth,
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: fullWidth * 0.03),
                          width: 2.5,
                          color: primaryColor,
                        ),

                        // Open content w/ full container
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(passSlug: content.slugName)),
                              );

                              passSlugContent = content.slugName;
                            },
                            child: GetHomePageEventContainer(
                                width: fullWidth, content: content))
                      ],
                    ),
                  ));
            }).toList()));
      } else {
        return SizedBox(
            height: fullHeight * 0.7,
            child: getMessageImageNoData("assets/icon/nodata2.png",
                "Sorry but we not found specific event", fullWidth));
      }
    }

    return Column(children: [
      Container(
        transform: Matrix4.translationValues(0, -10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getTitleLarge("What's New", greybg),
            const Spacer(),
            // SortingButton(
            //   active: sortingHomepageContent,
            //   action: updateSorting,
            // ),
            ControlPanel(
                titleCtrl: titleCtrl,
                setDateStartCtrl: updateDateStart,
                setDateEndCtrl: updateDateEnd,
                dateStart: filterDateStart,
                dateEnd: filterDateEnd),
          ],
        ),
      ),
      getData(contents)
    ]);
  }
}

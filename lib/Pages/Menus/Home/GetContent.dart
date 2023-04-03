import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_fik/Components/Skeletons/content_1.dart';
import 'package:mi_fik/Modules/Helpers/Widget.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Services/Queries/ContentQueries.dart';
import 'package:mi_fik/Pages/Menus/Home/Detail/index.dart';
import 'package:mi_fik/main.dart';

class GetContent extends StatefulWidget {
  const GetContent({Key key}) : super(key: key);

  @override
  _GetContent createState() => _GetContent();
}

class _GetContent extends State<GetContent> with TickerProviderStateMixin {
  ContentQueriesService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ContentQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiService.getAllContent("all", "DESC", "all", " ", 1),
        builder:
            (BuildContext context, AsyncSnapshot<List<ContentModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ContentModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const ContentSkeleton1();
          }
        },
      ),
    );
  }

  Widget _buildListView(List<ContentModel> contents) {
    //double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Column(
        children: contents.map((content) {
      return SizedBox(
          width: fullWidth,
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: fullWidth * 0.03),
                  width: 2.5,
                  color: primaryColor,
                ),

                //    CONTENT DOT????

                // Container(
                //   width: 20,
                //   margin: EdgeInsets.symmetric(
                //       horizontal: fullWidth * 0.01),
                //   transform: Matrix4.translationValues(
                //       0.0, -15.0, 0.0),
                //   decoration: BoxDecoration(
                //       color: mainbg,
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //         color: primaryColor,
                //         width: 2.5,
                //       )),
                // ),

                // Open content w/ full container
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(passSlug: content.slugName)),
                    );

                    passSlugContent = int.parse(content.slugName);
                  },
                  child: Container(
                      width: fullWidth * 0.82,
                      margin: EdgeInsets.only(bottom: marginMD),
                      transform: Matrix4.translationValues(40.0, 5.0, 0.0),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 108.0,
                            width: fullWidth,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: getImageHeader(content.contentImage),
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getViewWidget(content.totalViews),
                                  const Spacer(),
                                  getUploadDateWidget(
                                      DateTime.parse(content.createdAt))
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(content.contentTitle,
                                      style: TextStyle(
                                          color: blackbg,
                                          fontWeight: FontWeight.bold,
                                          fontSize: textMD)),
                                  getDescHeaderWidget(content.contentDesc)
                                ]),
                          ),

                          //Open content w/ button.
                          Container(
                              transform:
                                  Matrix4.translationValues(0.0, 5.0, 0.0),
                              padding: EdgeInsets.zero,
                              width: fullWidth,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            passSlug: content.slugName)),
                                  );

                                  passSlugContent = int.parse(content.slugName);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          primaryColor),
                                ),
                                child: const Text('Detail'),
                              ))
                        ],
                      )),
                )
              ],
            ),
          ));
    }).toList());
  }
}

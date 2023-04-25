import 'package:flutter/material.dart';

import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/HelpApi/Services/queries.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class GetAllHelpType extends StatefulWidget {
  const GetAllHelpType({Key key, this.passSlug}) : super(key: key);
  final String passSlug;

  @override
  _GetAllHelpType createState() => _GetAllHelpType();
}

class _GetAllHelpType extends State<GetAllHelpType> {
  HelpQueriesService apiQuery;

  @override
  void initState() {
    super.initState();
    apiQuery = HelpQueriesService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: FutureBuilder(
        future: apiQuery.getHelpType(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HelpTypeModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<HelpTypeModel> contents = snapshot.data;
            return _buildListView(contents);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<HelpTypeModel> contents) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
        itemCount: contents.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFe8e8e8), width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              iconColor: primaryColor,
              textColor: primaryColor,
              title: Text(ucFirst(contents[index].helpType),
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Lorem ipsum', style: TextStyle(color: greybg)),
              children: [],
            ),
          );
        });
  }
}

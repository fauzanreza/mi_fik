import 'package:flutter/material.dart';
import 'package:mi_fik/Components/Bars/top_bar.dart';
import 'package:mi_fik/Modules/Variables/style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    //double fullHeight = MediaQuery.of(context).size.height;
    //double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppbar("Setting", () {
        Navigator.pop(context);
      }),
      body: ListView(
        children: [
          TextButton(
            onPressed: () => throw Exception(),
            child: const Text("Error testing"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: successbg,
        tooltip: "Ask a question",
        child: const Icon(Icons.headset_mic),
      ),
    );
  }
}

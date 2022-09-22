import 'package:flutter/material.dart';
import 'package:mi_fik/Others/custombg.dart';
import 'package:mi_fik/main.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';

class addPost extends StatelessWidget {
  const addPost({super.key});

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          child: Stack(
               alignment: Alignment.topCenter,
            
            children: <Widget>[
              Container(
                height: fullHeight,
                width: fullWidth,
              ),
               Positioned(
                top: -10.0,
                child: Container(
                height: 250.0,
                width: fullWidth,
                decoration: BoxDecoration(
                image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: const AssetImage(
                 'assets/content/content-2.jpg'),
                  colorFilter:
                  ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                    BlendMode.darken),
                    ),
                    ),
                  child: MaterialButton(     
                    padding: const EdgeInsets.only(top: 40, left: 10),                     
                    child: Align(
                     alignment: Alignment.topLeft,
                     child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                    Navigator.pop(context);
                    },
                  )
              ),
               ),
              
    Positioned(
                top: 180.0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                                      color: mainbg,
                                      borderRadius: BorderRadius.only(
                                          topLeft: roundedLG, topRight: roundedLG),
                                    ),
                  child: LayoutBuilder(
                  builder: (context, constraints) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: fullHeight * 0.04),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  
                        children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: 'Title',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(width: 1,color: primaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(width: 1,color: primaryColor),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true),
                                        
                                    ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                        child: TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: 'Content',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(width: 1,color: primaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(width: 1,color: primaryColor),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true),
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                        
                                    ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: SizedBox(
                                          width: 200, // <-- Your width
                                          height: 50,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: primaryColor,
                                          side: BorderSide(width: 1.0, color: primaryColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      ),
                                      onPressed: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                                      }, 
                                      icon: Icon(Icons.attach_file),  //icon data for elevated button
                                      label: Text("Insert Attachment"),
                                       //label text 
                                      
                                  ),
                                        ),
                                    
                                      ),
                                      Container(
                                      alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                      child: Text("Choose Tags",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                        child: SizedBox(
                                          width: 105, // <-- Your width
                                          height: 30,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0)
                                      ),
                                      ),
                                      onPressed: () async {
                                      }, 
                                      icon: Icon(Icons.circle, color: Colors.yellow),  //icon data for elevated button
                                      label: const Text(
                                        'Studio 4',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                       //label text 
                                      
                                  ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                        child: SizedBox(
                                          width: 85, // <-- Your width
                                          height: 30,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0)
                                      ),
                                      ),
                                      onPressed: () async {
                                      }, 
                                      icon: Icon(Icons.circle, color: primaryColor),  //icon data for elevated button
                                      label: const Text(
                                        'DKV',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                       //label text 
                                      
                                  ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                        child: SizedBox(
                                          width: 140, // <-- Your width
                                          height: 30,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0)
                                      ),
                                      ),
                                      onPressed: () async {
                                      }, 
                                      icon: Icon(Icons.circle, color: Colors.blueAccent),  //icon data for elevated button
                                      label: const Text(
                                        'Designpreneur',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                       //label text 
                                      
                                  ),
                                        ),
                                      )
                                      ]
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                          child: TextButton.icon( 
                                              style: TextButton.styleFrom(
                                              textStyle: const TextStyle(fontSize: 16),
                                              foregroundColor: primaryColor,
                                            ),    // <-- TextButton
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.location_pin,
                                            size: 24.0,
                                          ),
                                          label: Text('Set My Location'),
                                      ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                        child: TextButton.icon( 
                                              style: TextButton.styleFrom(
                                              textStyle: const TextStyle(fontSize: 16),
                                              foregroundColor: primaryColor,
                                            ),    // <-- TextButton
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.calendar_month,
                                            size: 24.0,
                                          ),
                                          label: Text('Set Date'),
                                        ),
                                      ),
                                      ]
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                          child: TextButton.icon( 
                                              style: TextButton.styleFrom(
                                              textStyle: const TextStyle(fontSize: 16),
                                              foregroundColor: primaryColor,
                                            ),    // <-- TextButton
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.timer_outlined,
                                            size: 24.0,
                                          ),
                                          label: Text('Set Time'),
                                      ),
                                        ),
                                      Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                          child: TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: const TextStyle(fontSize: 16),
                                            foregroundColor: primaryColor,
                                          ),
                                          onPressed: () {},
                                          
                                          child: const Text('Reminder :'),
                                        ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: primaryColor,
                                          side: BorderSide(width: 1.0, color: primaryColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      ),
                                        onPressed: () {},
                                        child: const Text('1 Hour Before'),
                                      ),
                                      ),
                                      ]
                                    ),
                                  ),
                                      ]
                                    ),
                                  ),
                                  
                        ],
                      ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
            onPressed: () {},
            child: const Text(
              'Post it',
              style: TextStyle(fontSize: 18),
            ),
    )
              ),
  ],
  
)!,
        ),
      
    );
  }
}

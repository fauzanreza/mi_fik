body: LayoutBuilder(
  builder: (context, constraints) => ListView(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    children: [
      SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
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
              child: ListView(
                children: [
                  Container(
                            
                            decoration: BoxDecoration(
                              color: mainbg,
                              borderRadius: BorderRadius.only(
                                  topLeft: roundedLG, topRight: roundedLG),
                            ),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                    maxLines: 3,
                                
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
                                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
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
                                  width: 90, // <-- Your width
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
                            ]),
                          ),
                ],
              )
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
      )
    ],
  ),
),
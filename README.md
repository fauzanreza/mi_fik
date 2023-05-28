# MI-FIK Mobile Documentation
- API Base URL : https://mifik.id

========================= Command =========================
# First Run
> flutter clean
> flutter pub get
> flutter run

# Run Application
> flutter run

# Add Packages
> flutter pub add << packages_name >>  

# Firebase CLI
> firebase logout
> firebase login

# Make Deployment
> flutter clean
> flutter pub get
> flutter build apk --release --no-tree-shake-icons 


========================= File & Structure Directory =========================
Assets (Image, Video)
Directory               : /assets

# Components 
    - Backgrounds : Custom backround using canvas
    - Bars : For page navigation between main-menu, sub-menu, bottomsheet, and side drawer
    - Dialogs : Success and failed pop up
    - Forms : Receive input from user and some can show the result
    - Skeletons : Loading container / layout

# Modules
   - APIs : Some API modules using laravel API
        - Models : Data mapping before sending to API endpoint. From json or to json
            - << Functionality Name >>
                - Commands : For insert, updated, and deleted SQL syntax
                - Query : For select SQL syntax
        - Services : Get and send data from models to API endpoint and get the response
            - << Functionality Name >>

    - Firebases :

    - Helpers : Sets of function or class that will converted data type, generated new data ,generated widget from data, or validate the data
    
    - Variables : Sets of style guides variables and global variables (used in dummy data, or input option)

# Pages
    - Landings : Pages outside the main-menu or sub-menu. Such as login, register, splash, forget pass, and get started
        - << Menus Name >>
            - index.dart : Main class that have scaffold. So it's act like screen and will hold some sets of layout
            - Usecases : Sets of layout (widget) that group by it's functionality. It will be related to Modules (API or Firebase)
    - MainMenus : Pages that will available on bottom navbar
    - SubMenus : Pages that will available after the user have interact to some button or container in main menu layout
    - Others : 

============================ Rules ===============================

# Class dan Function rules
> Class using uppercase in first char, not using underscore
> Function using lowercase in first char

# Dart file rules
> file_name.dart
> Each one file contain max 500 SLOC
> Using lowercase and underscore 
> One pages folder only have one index.dart

==================================================================
Last Updated : 28 May 2023
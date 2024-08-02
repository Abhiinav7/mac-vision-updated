import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv/common/widgets/custom_textField.dart';
import 'package:tv/screen/stream/stream_screen.dart';
import '../common/widgets/tabs.dart';
import '../screen/Auth/hotel.dart';
import '../screen/home/home_screen.dart';
import '../screen/inbox/inbox_screen.dart';
import '../screen/info/more_details.dart';
import '../screen/mess/menu_screen.dart';
import '../screen/services/room_services.dart';
import '../screen/tv/tv_screen.dart';

class MainController extends ChangeNotifier {
  int selectedPages = 0;

  void changeSelectedPages(int index) {
    selectedPages = index;
    notifyListeners();
  }


  List<Widget> get pages => [
          const HomeScreen(),
          const TvScreen(),
          const StreamScreen(),
          const RoomService(),
          const MenuScreen(),
          const InboxScreen(),
          const MoreDetailScreen(),
        ];
  List<Widget> get tabs =>
      [
          const BottomTab(iconName: "Home", icon: "assets/icon/home.png"),
          const BottomTab(iconName: "Live Tv", icon: "assets/icon/tv.png"),
          const BottomTab(icon: "assets/icon/stream.png", iconName: "Stream"),
          const BottomTab(icon: "assets/icon/service.png", iconName: "Services"),
          const BottomTab(icon: "assets/icon/mess.png", iconName: "Menu"),
          const BottomTab(icon: "assets/icon/inbox.png", iconName: "Inbox"),
          const BottomTab(icon: "assets/icon/more.png", iconName: "More"),
        ];

//to open the system settings
  void openSettings() {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.SETTINGS',
    );
    intent.launch();
  }
//to rest the shared pref that save the hotel logged status
  hotelReset(BuildContext context) async {
    SharedPreferences hotelData = await SharedPreferences.getInstance();
    await hotelData.remove('hotel_registered').then((value) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Text("Your system is reset"),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HotelRegister()),
            (Route<dynamic> route) => false,
      );
    });
  }

  final FocusNode textFieldFocus = FocusNode();
  final FocusNode buttonFocus = FocusNode();

  //this alert box is used to logout the tv/update app
  dialogPermission({
    required BuildContext context,
    required String hotelId,
    required String title,
    required Size size,
    required Function function
  }) {
    TextEditingController hotelIdController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DegularDemo',
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * 0.035)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter ID",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DegularDemo',
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.015),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              CustomTextField(
                controller: hotelIdController,
                label: "Hotel id",
                hintText: "Enter hotel id",
                focusNode: textFieldFocus,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(buttonFocus),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              focusNode: buttonFocus,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  Text(title,style: const TextStyle(
                color: Colors.white
              ),),
              onPressed:(){
                String id = hotelIdController.text;
                if (id == hotelId) {
                  function();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Entered Hotel id is wrong"),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool _isAlertOpen = false;

  bool get isAlertOpen => _isAlertOpen;

//dialog for showing permission required for streaming apps
  void showFoodMenu({required BuildContext context, required Size size}) {
    FocusNode doneButton = FocusNode();

    _isAlertOpen = true;
    notifyListeners();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.blue,
          titleTextStyle: TextStyle(
              fontSize: size.width * 0.035,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
              fontFamily: 'DegularDemo'),
          title: const Text(
            'Permission Required',
          ),
          content: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "This Option Required Permission from admin",
                  style: TextStyle(
                    fontFamily: 'DegularDemo',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isAlertOpen = false;
                notifyListeners();
              },
              focusNode: doneButton,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.blue.withOpacity(0.4);
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isAlertOpen = false;
      notifyListeners();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      doneButton.requestFocus();
    });
  }

//this alert box show the permission required message
   showServiceDialog({required BuildContext context, required Size size}) {
    FocusNode doneButton = FocusNode();

    _isAlertOpen = true;
    notifyListeners();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.blue,
          titleTextStyle: TextStyle(
              fontSize: size.width * 0.035,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
              fontFamily: 'DegularDemo'),
          title: const Text(
            'Permission Required',
          ),
          content: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "This Option Required Permission from admin",
                  style: TextStyle(
                    fontFamily: 'DegularDemo',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isAlertOpen = false;
                notifyListeners();
              },
              focusNode: doneButton,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.blue.withOpacity(0.4);
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isAlertOpen = false;
      notifyListeners();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      doneButton.requestFocus();
    });
  }


  final FocusNode firstChannelFocusNode = FocusNode();

  void focusFirstNode() {
    if (!firstChannelFocusNode.hasFocus) {
      firstChannelFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    firstChannelFocusNode.dispose();
    super.dispose();
  }
}

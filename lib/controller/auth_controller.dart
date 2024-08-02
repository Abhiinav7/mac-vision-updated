import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final FocusNode roomFocusNode = FocusNode();
  final FocusNode hotelIdFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();

  TextEditingController hotelIdController = TextEditingController();
  TextEditingController roomNoController = TextEditingController();

  void saveHotelDetails() async {
    SharedPreferences hotelData = await SharedPreferences.getInstance();
    await hotelData.setString('h_id', hotelIdController.text);
    await hotelData.setString('r_no', roomNoController.text);
    hotelData.setBool('hotel_registered', true);
  }

  //function for app exit
  Future<void> exitApp({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  //this alert box used for saving hotel credentials when first time login
  void showRestartDialog(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: size.width * 0.01),
              const Text("App Rebuilding"),
            ],
          ),
          content: const Text("App requires restart "),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Restart",
                style: TextStyle(color: Colors.white,),
              ),
              onPressed: () {
                exitApp();
              },
            ),
          ],
        );
      },
    );
  }
}

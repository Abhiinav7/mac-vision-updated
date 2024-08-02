import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/main_controller.dart';
import '../common/widgets/stream_container.dart';
import '../constants/constants.dart';
import '../services/stream_services.dart';

class RoomServiceController extends ChangeNotifier {

//this function is used to book the services
  Future<void> postService({
      required hotelId,
      required roomNo,
      required serviceId,
      required serviceType
  }) async {
    String url = "${commonUrl}make-order.php";
    Map<String, dynamic> body = {
      'h_id': hotelId,
      'room_no': roomNo,
      'item_id': serviceId,
      'service_type': serviceType,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return;
    }
  }

  bool _isAlertBoxOpen = false;

  bool get isAlertBoxOpen => _isAlertBoxOpen;
  //dialog for serive booking
  void showServiceDialog({
    required BuildContext context,
    required String serviceName,
    required String serviceDescription,
    required String serviceId,
    required String serviceType,
    required Size size,
    required String hId,
    required String rNo,
  }) {
    FocusNode sendButtonFocusNode = FocusNode();
    FocusNode cancelButtonFocusNode = FocusNode();

    _isAlertBoxOpen = true;
    notifyListeners();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.blue,
          titleTextStyle:  TextStyle(
              fontSize: size.width * 0.035,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
              fontFamily: 'DegularDemo'),
          title: const Text(
            'Service Booking',
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Would you like to book the '$serviceName' service?",
                  style:  TextStyle(
                    fontFamily: 'DegularDemo',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.022,
                  ),
                ),
                Text(
                  "Description : $serviceDescription",
                  style:  TextStyle(
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
                _isAlertBoxOpen = false;
                notifyListeners();
              },
              focusNode: cancelButtonFocusNode,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.red.withOpacity(0.7);
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                postService(
                    hotelId: hId,
                    roomNo: rNo,
                    serviceId: serviceId,
                    serviceType: serviceType)
                    .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Your service has been booked")),
                ))
                    .then((value) => Navigator.pop(context))
                    .then((value) {
                  _isAlertBoxOpen = false;
                  notifyListeners();
                });
              },
              focusNode: sendButtonFocusNode,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.green.withOpacity(0.7);
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: const Text('Book', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    ).then((_) {
      _isAlertBoxOpen = false;
      notifyListeners();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      sendButtonFocusNode.requestFocus();
    });
  }

  bool isClicked = false;

  void changeClicked() {
    isClicked = true;
    notifyListeners();
  }

//dialog for showing streaming apps like youtube,netflix
  void showAvailableMedia({required BuildContext context,required Size size}) {
    FocusNode firstNode = FocusNode();
    FocusNode secondNode = FocusNode();
    FocusNode thirdNode = FocusNode();
    FocusNode forthNode = FocusNode();
    _isAlertBoxOpen = true;
    notifyListeners();
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamContainer(
                onTap: () => StreamServices.launchYoutubeApp(),
                focusNode: firstNode,
                title: "YouTube",
                img: "assets/ott/youtube.png",
              ),
              StreamContainer(
                onTap: () {
                Provider.of<MainController>(context,listen: false).showFoodMenu(context: context,size: size );
                },
                focusNode: secondNode,
                title: "NetFlix",
                img: "assets/ott/netflix.png",
                // onTap: () =>
                //     StreamServices.launchStreamingApp(context, "netflix"),
              ),
              StreamContainer(
              onTap: ()=>Provider.of<MainController>(context,listen: false).showFoodMenu(context: context,size: size ),
                // onTap: () =>
                //     StreamServices.launchStreamingApp(context, "amazon prime"),
                focusNode: thirdNode,
                title: "Amazon Prime",
                img: "assets/ott/prime.png",
              ),
              StreamContainer(
                onTap: ()=>Provider.of<MainController>(context,listen: false).showFoodMenu(context: context,size: size ),
                // onTap: () => StreamServices.launchHotstarApp(),
                focusNode: forthNode,
                title: "Hotstar",
                img: "assets/ott/hotstar.png",
              ),
            ],
          ),
        );
      },
    ).then((_) {
      isClicked = false;
      _isAlertBoxOpen = false;
      notifyListeners();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      firstNode.requestFocus();
    });
  }
}

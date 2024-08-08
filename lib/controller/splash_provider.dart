import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../constants/constants.dart';
import '../screen/Auth/hotel.dart';
import '../screen/main_screen.dart';

class SplashProvider extends ChangeNotifier{
  bool hotelRegistered = false;
  late VideoPlayerController controller;

  SplashProvider() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    checkHotelCred();
    playSplash();
  }
  Future<void> playSplash() async {
    controller = VideoPlayerController.asset('assets/splash/intro.mp4')
      ..initialize().then((_) {
        controller.play();
        notifyListeners();
      });
    controller.addListener(() {
      if (controller.value.position == controller.value.duration) {
        navigateToNextPage();
      }
    });
  }

  Future<void> checkHotelCred() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    hotelRegistered = preferences.getBool('hotel_registered') ?? false;
    notifyListeners();
  }

  void navigateToNextPage() {
    if (hotelRegistered) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
            (e) => false,
      );
    } else {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HotelRegister()),
            (e) => false,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
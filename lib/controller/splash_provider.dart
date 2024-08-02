import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/Auth/hotel.dart';
import '../screen/main_screen.dart';

class SplashProvider extends ChangeNotifier{
  bool hotelRegistered = false;
  late VlcPlayerController vlcController;

  SplashProvider() {
    hotelCheck();
    playSplash();
  }
 void playSplash(){
   vlcController = VlcPlayerController.asset(
       'assets/splash/intro.mp4',
       autoPlay: true,
       hwAcc: HwAcc.auto,
       autoInitialize: true,
       options: VlcPlayerOptions()
   );
 }

  Future<void> hotelCheck() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    hotelRegistered = preferences.getBool('hotel_registered') ?? false;
    notifyListeners();
  }

  void navigateToNextPage(BuildContext context) {
    if (hotelRegistered) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
            (e) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HotelRegister()),
            (e) => false,
      );
    }
  }

  @override
  void dispose() {
    vlcController.dispose();
    super.dispose();
  }
}
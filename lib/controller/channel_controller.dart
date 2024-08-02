import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/channel_model.dart';

class ChannelProvider with ChangeNotifier {
  ChannelProvider() {
    fetchHotelCredentials();
  }

  String hotelId = '';
  String roomNo = '';

  void fetchHotelCredentials() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    String? rNo = sharedPreferences.getString("r_no");
    hotelId = hId ?? '';
    roomNo = rNo ?? '';
    notifyListeners();
  }

  List<Channel>? channels;


  late VlcPlayerController vlcPlayerController;

  void playChannel(String videoUrl) {
    vlcPlayerController = VlcPlayerController.network(
      videoUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      autoInitialize: true,
      allowBackgroundPlayback: false,
      options: VlcPlayerOptions(),
    );
    notifyListeners();
  }

  void disposeVlcPlayer() {
    vlcPlayerController.dispose();
    notifyListeners();
  }

}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class HotelController extends ChangeNotifier {
  List<String> imgList = [];
  bool isLoading = false;
  bool isLoad = false;
  String? hotelName;
  String? hotelLocation;
  String? hotelLogo;
  String? hotelPhone;
  String? hotelEmail;

  HotelController() {
    getHotelDetails();
  }

  void getHotelDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    await fetchHotelImages(hId!);
    await fetchHotelDetails(hId);
  }

  Future<void> fetchHotelImages(String hotelId) async {
    const String url =
        '${commonUrl}view_hotel_images.php';

    Map<String, String> body = {
      'h_id': hotelId,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {

        Map<String, dynamic> data = jsonDecode(response.body);
        imgList = [
          '$getUrl${data['data'][0]['h_image1']}',
          '$getUrl${data['data'][0]['h_image2']}',
          '$getUrl${data['data'][0]['h_image3']}',
        ];
        isLoading = true;
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      isLoading = false;
      notifyListeners();
    }
  }



  Future<void> fetchHotelDetails(String hotelId) async {
    const String url =
        '${commonUrl}view_hotels.php';

    Map<String, String> body = {
      'h_id': hotelId,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        hotelName=data["data"]["name"];
        hotelLocation=data["data"]["city"];
        hotelEmail=data["data"]["h_email"];
        hotelPhone=data["data"]["phone"];
        hotelLogo=data["data"]["h_logo"];
        isLoad=true;
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

}

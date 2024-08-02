import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/food_menu_model.dart';

class ApiServices {
  Future<String> getChannelUrl(String hotelId, String roomNo) async {
    const String url = '${commonUrl}ip_data.php';

    Map<String, String> body = {
      'h_id': hotelId,
      'room_no': roomNo,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        String channelUrl = parsedJson["data"]["channel_url"].toString();
        return channelUrl;
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return "";
    }
  }

 static Future getPrivateMessages(String hotelId, String roomNo) async {
    const String url = '${commonUrl}view-message.php';

    Map<String, String> body = {
      'h_id': hotelId,
      'room_no': roomNo,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        String message = parsedJson["data"]["message"].toString();
        return message;
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return "";
    }
  }

  static Stream getPublicMessages(String hotelId) async* {
    const String url = '${commonUrl}hotel_info.php';

    Map<String, String> body = {
      'h_id': hotelId,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        yield parsedJson;

      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        yield "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      yield "";
    }
  }

 static Future<List<Map<String, dynamic>>> getMessDetails() async {
    const String url = '${commonUrl}view_food_details.php';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    Map<String, String> body = {
      'h_id': hId!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(parsedJson['data']);
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return [];
    }
  }

  static Future<String> getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    String? rNo = sharedPreferences.getString("r_no");
    const String url = '${commonUrl}view-customer.php';

    Map<String, String> body = {
      'h_id': hId.toString(),
      'room_no': rNo.toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["data"] != null && data["data"][0]["c_name"] != null) {
          String name = data["data"][0]["c_name"].toString();
          return name;
        } else {
          if (kDebugMode) {
            print('No customer data found');
          }
          return "";
        }
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return "";
    }
  }

  static Future<FoodMenu?> getFoodMenu() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    const String url = '${commonUrl}view-food-item.php';

    Map<String, String> body = {
      'h_id': hId!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        // Map<String, dynamic> parsedJson = jsonDecode(response.body);
        return foodMenuFromJson(response.body);
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return null;
    }
  }

  static Future<dynamic> viewFoodOrder() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    String? rNo = sharedPreferences.getString("r_no");
    const String url = '${commonUrl}food_order_history.php';

    Map<String, String> body = {
      'h_id': hId!,
      'room_no': rNo.toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        return parsedJson;
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return null;
    }
  }

  static Future<void> postFoodOrder({
      required hotelId,
      required roomNo,
      required serviceId,
      required serviceType,
      required  quantity}) async {
    String url = "${commonUrl}make-order.php";
    Map<String, dynamic> body = {
      'h_id': hotelId,
      'room_no': roomNo,
      'item_id': serviceId,
      'service_type': serviceType,
      'qty': quantity,
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

  static Future<void> postMessages({
    required hotelId,
    required roomNo,
   required messages
  }) async {
    String url = "${commonUrl}sent-message.php";
    Map<String, dynamic> body = {
      'h_id': hotelId,
      'room_no': roomNo,
      'message': messages,
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

  //this function returns list of services
  static Future<List<Map<String, dynamic>>> getService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? hId = sharedPreferences.getString("h_id");
    const String url = '${commonUrl}view-services.php';

    Map<String, String> body = {
      'h_id': hId!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(parsedJson['data']);
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return [];
    }
  }

}

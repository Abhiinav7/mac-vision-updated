import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherController extends ChangeNotifier {
    Future<String> getData(String place) async {
    String baseurl = "api.weatherapi.com";
    String key = '4b9be6fb1718410c8a972224232811';

    final queryParameters = {
      "key": key,
      "q": place,

    };
    var url = Uri.https(baseurl, '/v1/current.json', queryParameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsedJson = jsonDecode(response.body);
      final String tempC = parsedJson['current']['temp_c'].toString();
     return tempC;
    }
    else {
      throw Exception("error");
    }
  }

}

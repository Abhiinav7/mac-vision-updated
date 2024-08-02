import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/channel_model.dart';
import 'package:http/http.dart' as http;

class ChannelServices {

  static Future<List<Channel>> getChannels() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? hId = sharedPreferences.getString("h_id");
      String? rNo = sharedPreferences.getString("r_no");
      const String url = '${commonUrl}ip_data.php';

      Map<String, String> body = {
        'h_id': hId!,
        'room_no': rNo!,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          body: body,
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> parsedJson = jsonDecode(response.body);
          String channelUrl = parsedJson["data"]["channel_url"].toString();
          final data = await http.get(Uri.parse("$getUrl$channelUrl"));

          if (data.statusCode == 200) {
            final String fileContent = data.body;
            final List<String> lines = fileContent.split('\n');
            final List<Channel> channels = [];
            String? currentName;

            for (final line in lines) {
              if (line.trim().isEmpty) continue;
              if (line.startsWith('#EXTINF')) {
                currentName = line.split(',')[1].trim();
              } else if (currentName != null) {
                channels.add(Channel(currentName, line.trim()));
                currentName = null;
              }
            }
            return channels;
          } else {
            throw Exception('Failed to load M3U file');
          }
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
  }

//old function that fetches channels and return to list

  // Future<List<Channel>> fetchM3UFile(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load M3U file');
  //   }
  //
  //   final String fileContent = response.body;
  //   final List<String> lines = fileContent.split('\n');
  //   final List<Channel> channels = [];
  //
  //   String? currentName;
  //
  //   for (final line in lines) {
  //     if (line
  //         .trim()
  //         .isEmpty) continue;
  //     if (line.startsWith('#EXTINF')) {
  //       currentName = line.split(',')[1].trim();
  //     } else if (currentName != null) {
  //       channels.add(Channel(currentName, line.trim()));
  //       currentName = null;
  //     }
  //   }
  //   return channels;
  // }


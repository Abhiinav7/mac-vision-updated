import 'package:android_intent/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class StreamServices{
  static Future<void> launchStreamingApp(BuildContext context, String appName) async {
    String packageName;
    String marketUrl;
    switch (appName.toLowerCase()) {
      case 'netflix':
        packageName ='com.netflix.ninja';
        marketUrl = 'market://details?id=com.netflix.ninja';
        break;
      case 'amazon prime':
        packageName = 'com.amazon.amazonvideo.livingroom';
        marketUrl = 'market://details?id=com.amazon.amazonvideo.livingroom';
        break;
      default:
        throw 'Unsupported app';
    }

    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      package: packageName,
    );
    try {
      await intent.launch();
    } catch (e) {
      final playStoreIntent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: marketUrl,
      );
      try {
        await playStoreIntent.launch();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open $appName or Play Store.')),
        );
      }
    }
  }

 static Future<void> launchYoutubeApp() async {
   const youtubeAppUrl = 'vnd.youtube://';
   const youtubeWebUrl = 'https://www.youtube.com';

   if (await canLaunch(youtubeAppUrl)) {
     await launch(youtubeAppUrl);
   } else if (await canLaunch(youtubeWebUrl)) {
     await launch(youtubeWebUrl, forceSafariVC: false);
   } else {
     throw 'Could not launch YouTube';
   }
 }
 static Future<void> launchHotstarApp() async {
   const hotstarAppUrl = 'hotstar://';
   const hotstarWebUrl = 'https://www.hotstar.com';

   if (await canLaunch(hotstarAppUrl)) {
     await launch(hotstarAppUrl);
   } else if (await canLaunch(hotstarWebUrl)) {
     await launch(hotstarWebUrl, forceSafariVC: false);
   } else {
     throw 'Could not launch Hotstar';
   }
 }


}
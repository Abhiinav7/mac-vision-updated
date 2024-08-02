import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/screen/splash/splash.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'controller/auth_controller.dart';
import 'controller/hotel_controller.dart';
import 'controller/main_controller.dart';
import 'controller/menu_controller.dart';
import 'controller/room_service_controller.dart';
import 'controller/splash_provider.dart';
import 'controller/update_controller.dart';
import 'controller/weather_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChannelProvider()),
        ChangeNotifierProvider(create: (context) => WeatherController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => RoomServiceController()),
        ChangeNotifierProvider(create: (context) => MainController()),
        ChangeNotifierProvider(create: (context) => HotelController()),
        ChangeNotifierProvider(create: (context) => UpdateController()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => SplashProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Macvision',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const SplashPage(),
      ),
    );
  }
}


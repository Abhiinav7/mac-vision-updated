import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/splash_provider.dart';
import 'package:video_player/video_player.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Consumer<SplashProvider>(
          builder: (context, value, child) {
            return VideoPlayer(value.controller);
          }
      )),
    );
  }
}

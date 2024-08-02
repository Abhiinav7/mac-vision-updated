import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';
import '../controller/channel_controller.dart';

class FullScreenVideoPlayer extends StatelessWidget {
  const FullScreenVideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final channelProvider=Provider.of<ChannelProvider>(context);
    return PopScope(
      onPopInvoked:(_)=>channelProvider.disposeVlcPlayer() ,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Consumer<ChannelProvider>(
                builder: (context, provider, child) {
                  return Center(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VlcPlayer(
                          controller: provider.vlcPlayerController,
                          aspectRatio: 16 / 9,
                          placeholder: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              child: IconButton(
                focusColor: Colors.indigo.shade600,
                color: Colors.white,
                onPressed: () {
                  channelProvider.disposeVlcPlayer();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

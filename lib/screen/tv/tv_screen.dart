import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
import 'package:tv/services/channel_services.dart';
import '../../controller/channel_controller.dart';
import '../../controller/main_controller.dart';
import '../../model/channel_model.dart';
import '../../videoplayer/video_player.dart';

class TvScreen extends StatelessWidget {
  const TvScreen({super.key});
  static Future<List<Channel>> getChannels = ChannelServices.getChannels();

  @override
Widget build(BuildContext context) {
    final mainController = Provider.of<MainController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainController.focusFirstNode();
    });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: size.height * 0.017),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Consumer<ChannelProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder<List<Channel>>(
                    future: getChannels,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading channels',
                            style: TextStyle(
                              fontFamily: 'DegularDemo',
                              color: Colors.white,
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No channels available',
                            style: TextStyle(
                              fontFamily: 'DegularDemo',
                              color: Colors.white,
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      final List<Channel> channels = snapshot.data!;

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: channels.length,
                        itemBuilder: (context, index) {
                          final channel = channels[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              left: size.height * 0.028,
                              top: size.height * 0.011,
                              right: size.height * 0.02,
                            ),
                            child: ListTile(
                              focusNode:
                              index == 0 ? mainController.firstChannelFocusNode : null,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(size.height * 0.0223),
                              ),
                              focusColor: const Color(0xff81d1ff),
                              tileColor: Colors.white,
                              title: Text(
                                channel.name,
                                style: TextStyle(
                                  fontSize: size.width * 0.02,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'DegularDemo',
                                ),
                              ),
                              onTap: () {
                                provider.playChannel(channel.url);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const FullScreenVideoPlayer()),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const Expanded(
                flex: 6,
                child: SizedBox()
            ),
          ],
        ),
      ),
    );
  }

}


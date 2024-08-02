import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/common/widgets/menu_tile.dart';
import '../../controller/main_controller.dart';
import '../../controller/room_service_controller.dart';

class StreamScreen extends StatelessWidget {
  const StreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final mainController = Provider.of<MainController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainController.focusFirstNode();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Stream",
            style: TextStyle(
            fontFamily: 'DegularDemo',
                color: Colors.white,
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Consumer<RoomServiceController>(builder: (context, value, child) {
          return Center(
            child: value.isClicked
                ? const SizedBox()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuTile(
                  focusNode: mainController.firstChannelFocusNode,
                    size: size,
                    img: "assets/img/vod.jpg",
                    title: "VOD",
                    subTitle: "Video on demand",
                    onTap: ()=>ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Currently not available"),
                                      behavior: SnackBarBehavior.floating,
                                    ))
                ),
                SizedBox(height: size.height * 0.01,),
                MenuTile(
                    size: size,
                    img: "assets/img/media.png",
                    title: "Media",
                    subTitle: "Streaming platforms",
                    onTap: (){
                      value.changeClicked();
                      value.showAvailableMedia(context: context,size: size);

                    }
                ),
              ],
            )
          );
        }));
  }
}

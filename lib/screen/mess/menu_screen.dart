import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/controller/menu_controller.dart';
import '../../common/widgets/menu_tile.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final menuController = Provider.of<MenuProvider>(context);
    final channelProvider = Provider.of<ChannelProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuController.focusFirstNode();
    });
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:!menuController.isClicked? Text(
            "Menu",
            style: TextStyle(
                fontFamily: 'DegularDemo',
                color: Colors.white,
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600),
          ):const SizedBox()
        ),
        body: Center(
          child: menuController.isClicked
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuTile(
                      size: size,
                      img: 'assets/img/order_food.jpg',
                      title: 'Food Menu',
                      subTitle: 'Explore a variety of delicious food.',
                      focusNode: menuController.firstFocusNode,
                      onTap: (){
                        menuController.changeClicked();
                        menuController.showFoodMenu(
                          hId: channelProvider.hotelId,
                            rNo: channelProvider.roomNo,
                            context: context, size: size);
                      }),
                    SizedBox(height: size.height * 0.01,),
                    MenuTile(
                      size: size,
                      img: 'assets/img/timing.jpg',
                      title: 'Mess Timing',
                      subTitle: 'Find the schedule for meal times.',
                      onTap: () {
                        menuController.changeClicked();
                        menuController.showMessTiming(size: size,context: context);
                      }),

                  ],
                ),
        ));
  }
}


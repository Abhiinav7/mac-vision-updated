import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/controller/update_controller.dart';
import '../../common/widgets/custom_tile.dart';
import '../../controller/main_controller.dart';
import 'company_info/company_details.dart';
import 'hotel_info/hotel_details.dart';

class MoreDetailScreen extends StatelessWidget {
  const MoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final mainController = Provider.of<MainController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainController.focusFirstNode();
    });
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(children: [
          Expanded(
              flex: 3,
              child: ListView(
                children: [
                  CustomTile(
                    onTap: mainController.openSettings,
                    icon: Icons.settings,
                    title: "Settings",
                    focusNode: mainController.firstChannelFocusNode,
                  ),
                  Consumer2<UpdateController,ChannelProvider>(
                    builder:(context, update,channel, child) =>  CustomTile(
                      onTap: ()=>mainController.dialogPermission(
                          context: context,
                          size: size,
                          title: "Update",
                          hotelId: channel.hotelId,
                          function: ()=>update.requestPermissionAndDownload(context)
                      ),
                      icon: Icons.system_update_alt_outlined,
                      title: "Update",
                    ),
                  ),
                  CustomTile(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const HotelDetailsDialog();
                        },
                      );
                    },
                    icon: Icons.info_outline,
                    title: "Info",
                  ),
                  CustomTile(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CompanyDetailsDialog();
                        },
                      );
                    },
                    icon: Icons.contact_support_outlined,
                    title: "Contact Us",
                  ),
                  Consumer<ChannelProvider>(
                    builder: (context, channelController, child) {
                      return CustomTile(
                        onTap:  ()=>mainController.dialogPermission(
                            context: context,
                          size: size,
                          title: "Logout",
                          hotelId: channelController.hotelId,
                          function: ()=>mainController.hotelReset(context)
                        ),
                        icon: Icons.logout_outlined,
                        title: "Logout",
                      );
                    }
                  ),
                ],
              )),
          const Expanded(flex: 6, child: SizedBox())
        ]));
  }

}



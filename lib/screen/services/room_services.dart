import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/services/api_services.dart';
import '../../controller/main_controller.dart';
import '../../controller/room_service_controller.dart';

class RoomService extends StatelessWidget {
  const RoomService({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> getServices=ApiServices.getService();
    Size size = MediaQuery.of(context).size;
    final channelProvider=Provider.of<ChannelProvider>(context);
    final mainController = Provider.of<MainController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainController.focusFirstNode();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Services",
          style: TextStyle(
              fontFamily: 'DegularDemo',
              color: Colors.white,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Consumer<RoomServiceController>(
              builder: (context, provider, child) {
                return FutureBuilder(
                  future: getServices,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white,));
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.white,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                            "No Service Available",
                            style: TextStyle(
                                fontFamily: 'DegularDemo',
                                color: Colors.white,
                                fontSize: size.height * 0.045,
                                fontWeight: FontWeight.w600),
                          ));
                    } else {
                      var services = snapshot.data!;
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(height: 3),
                        shrinkWrap: true,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                left: size.height * 0.028,
                                top: size.height * 0.011,
                                right: size.height * 0.02),
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
                                service["s_name"],
                                style: TextStyle(
                                  fontFamily: 'DegularDemo',
                                  fontSize: size.width * 0.02,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                provider.showServiceDialog(
                                    hId: channelProvider.hotelId,
                                    rNo: channelProvider.roomNo,
                                    size: size,
                                    context: context,
                                    serviceName: service["s_name"],
                                    serviceDescription:
                                    service["s_description"] ?? " ",
                                    serviceId: service["s_id"],
                                    serviceType: "service");

                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
          const Expanded(flex: 6, child: Center(child: SizedBox())),
        ],
      ),
    );
  }

}


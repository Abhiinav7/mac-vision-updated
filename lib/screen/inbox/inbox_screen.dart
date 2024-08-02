import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/controller/menu_controller.dart';
import 'package:tv/services/api_services.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final channelProvider=Provider.of<ChannelProvider>(context);
    final menuProvider=Provider.of<MenuProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!menuProvider.isAlertOpen){
        menuProvider.firstFocusNode.requestFocus();
      }
    });
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Message",
            style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600,
                fontFamily: 'DegularDemo'),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<dynamic>(
                future: ApiServices.getPrivateMessages(
                    channelProvider.hotelId, channelProvider.roomNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Technical error'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.data == null) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.25),
                      child: Text(
                        "You don't have any message",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.032,
                            fontFamily: 'DegularDemo',
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    var item = snapshot.data;
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                focusColor: const Color(0xff81d1ff),
                                onPressed: () {
                                  menuProvider.scrollController.animateTo(
                                    menuProvider.scrollController.offset - 100,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.1,
                              ),
                              IconButton(
                                focusColor: const Color(0xff81d1ff),
                                onPressed: () {
                                  menuProvider.scrollController.animateTo(
                                    menuProvider.scrollController.offset + 100,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "You have a message",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.032,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DegularDemo'),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: size.height * 0.40),
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: size.height * 0.38),
                                        margin: EdgeInsets.only(
                                          right: size.width * 0.015,
                                          top: size.height * 0.01,
                                          bottom: size.height * 0.01,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.014,
                                            vertical: size.height * 0.02),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: SingleChildScrollView(
                                          controller: menuProvider.scrollController,
                                          child: Text(item,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * 0.022,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                             ElevatedButton(
                                 focusNode:menuProvider.firstFocusNode ,
                                 onPressed: (){
                                  menuProvider.sendMessage(
                                      context: context, size: size,
                                      hotelId: channelProvider.hotelId,
                                      roomNo:channelProvider.roomNo ,
                                  );
                                 }, child: const Text("Reply"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              //this stream builder fetch the public broadcast messages
              StreamBuilder(
                stream: ApiServices.getPublicMessages(channelProvider.hotelId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.data == null ||
                      snapshot.data["data"] == null) {
                    return const SizedBox();
                  } else {
                    var data = snapshot.data;
                    return SizedBox(
                      height: size.height * 0.12,
                      child: Marquee(
                        text:
                            "Date : ${data["data"]["initial_date"].toString()}\nMsg : ${data["data"]["h_message"].toString()} ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontSize: size.width * 0.023,
                          fontFamily: 'DegularDemo',
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 600,
                        velocity: 20.0,
                        // pauseAfterRound: Duration(seconds:1),
                        // startPadding: 10.0,
                        // accelerationDuration: Duration(seconds: 0),
                        accelerationCurve: Curves.linear,
                        // decelerationDuration: Duration(seconds: 0),
                        decelerationCurve: Curves.linear,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      );

  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tv/common/widgets/shimmer.dart';
import 'package:tv/controller/channel_controller.dart';
import 'package:tv/controller/hotel_controller.dart';
import 'package:tv/services/api_services.dart';
import '../../controller/weather_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Future<String> userDetailsFuture = ApiServices.getUserDetails();

  @override
  Widget build(BuildContext context) {
    final hotelController = Provider.of<HotelController>(context);
    final weatherController = Provider.of<WeatherController>(context);
    final channelController = Provider.of<ChannelProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(
            left: size.height * 0.0222,
            right: size.height * 0.0222,
            top: size.height * 0.008),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 4),
                FutureBuilder<String>(
                  future: userDetailsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty ||
                        snapshot.data == null) {
                      return Text(
                        "Welcome ",
                        style: TextStyle(
                            fontFamily: 'DegularDemo',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: size.height * 0.070),
                      );
                    } else {
                      return Row(
                        children: [
                          Text(
                            "Welcome ",
                            style: TextStyle(
                                fontFamily: 'DegularDemo',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: size.height * 0.057),
                          ),
                          SizedBox(
                            width: size.width * 0.43,
                            child: FittedBox(
                              alignment: Alignment.bottomLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                    fontFamily: 'DegularDemo',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.height * 0.053),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const Spacer(),
                FutureBuilder<String>(
                  future: weatherController
                      .getData(hotelController.hotelLocation.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      final weatherData = snapshot.data!;
                      return Row(
                        children: [
                          Image.asset(
                            "assets/icon/weather.png",
                            height: 30,
                            fit: BoxFit.fitHeight,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "$weatherData°C",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: size.width * 0.03,
                                fontFamily: 'DegularDemo'),
                          )
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(width: 25),
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Text(
                        DateFormat('EEE dd MMM').format(DateTime.now()),
                        style: TextStyle(
                            fontFamily: 'DegularDemo',
                            fontSize: size.width * 0.025,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      );
                    }),
                Text(
                  "|",
                  style: TextStyle(
                      fontFamily: 'DegularDemo',
                      fontSize: size.width * 0.024,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      DateFormat('HH:mm').format(DateTime.now()),
                      style: TextStyle(
                          fontFamily: 'DegularDemo',
                          fontSize: size.width * 0.028,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  "Room No : ${channelController.roomNo}",
                  style: TextStyle(
                      fontFamily: 'DegularDemo',
                      fontSize: size.height * 0.040,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            hotelController.isLoading
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * 0.0222),
                    child: hotelController.imgList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : CarouselSlider(
                            options: CarouselOptions(
                              height: size.height / 1.54,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.easeInOutQuad,
                              enableInfiniteScroll: true,
                              autoPlayInterval: const Duration(seconds: 15),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1200),
                              viewportFraction: 1,
                            ),
                            items: hotelController.imgList.map((i) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.height * 0.0222),
                                ),
                                child: CachedNetworkImage(
                                  width: size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: i,
                                  placeholder: (context, url) => MyShimmer(
                                    width: size.width,
                                    radius: size.height * 0.0222,
                                    height: size.height / 1.53,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  )
                : MyShimmer(
                    height: size.height / 1.54,
              width: size.width,
                    radius: size.height * 0.0222,
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tv/model/food_menu_model.dart';
import '../common/widgets/shimmer.dart';
import '../constants/constants.dart';
import '../services/api_services.dart';

class MenuProvider extends ChangeNotifier {
  bool _isAlertOpen = false;

  bool get isAlertOpen => _isAlertOpen;

  bool isClicked = false;

  void changeClicked() {
    isClicked = true;
    notifyListeners();
  }

//this alert box shows the list of food items available
  void showFoodMenu(
      {required BuildContext context,
      required Size size,
      required String hId,
      required String rNo}) {
    FocusNode firstNode = FocusNode();
    _isAlertOpen = true;
    notifyListeners();
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // this is to Calculate total height for exactly two Row of grids
        const int crossAxisCount = 5;
        const double childAspectRatio = 0.83;
        const double spacing = 12.0;
        double itemWidth =
            (size.width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        double itemHeight = itemWidth / childAspectRatio;
        double dialogHeight = itemHeight * 2 + spacing;

        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          alignment: Alignment.topLeft,
          scrollable: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: dialogHeight - spacing,
                    child: FutureBuilder<FoodMenu?>(
                        future: ApiServices.getFoodMenu(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          } else if (!snapshot.hasData) {
                            return Center(
                                child: Text("Menu not Available",
                                    style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        color: Colors.white,
                                        fontFamily: 'DegularDemo',
                                        fontWeight: FontWeight.w600)));
                          } else {
                            final item = snapshot.data;
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 0.83),
                              itemCount: item?.data.length,
                              itemBuilder: (context, index) {
                                final foodMenu = item?.data[index];
                                return InkWell(
                                  onTap: () {
                                  },
                                  focusColor: Colors.lightBlue,
                                  focusNode: index == 0 ? firstNode : null,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    width: size.width * 0.19,
                                    height: size.height * 0.50,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(12)),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    MyShimmer(
                                                      width: size.width * 0.19,
                                                      radius: 12,
                                                      color: Colors.grey,
                                                    ),
                                                imageUrl:
                                                    "$getUrl${foodMenu?.foodImage}",
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: size.height * 0.095,
                                          width: size.width * 0.19,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(12)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${foodMenu?.foodName}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'DegularDemo',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.width * 0.017,
                                                ),
                                              ),
                                              Text(
                                                "Price : ${foodMenu?.foodPrice}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'DegularDemo',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.width * 0.015,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.18,
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      isClicked = false;
      _isAlertOpen = false;
      notifyListeners();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      firstNode.requestFocus();
    });
  }


  final ScrollController scrollController = ScrollController();

  //this alert is for message
  void sendMessage({
    required BuildContext context,
    required Size size,
    required String hotelId,
    required String roomNo,

  }) {
    _isAlertOpen = true;
    notifyListeners();
    FocusNode firstNode = FocusNode();
    FocusNode buttonFocus = FocusNode();
    TextEditingController textEditingController=TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          alignment: Alignment.center,
          scrollable: true,
          elevation: 0,
          title: const Text("Enter Message"),
          content: SizedBox(
            height: size.height * 0.1,
            width: size.width / 1.5,
            child: TextField(
              maxLines: 1,
              controller: textEditingController,
              decoration: const InputDecoration(hintText: "Type here"),
              focusNode: firstNode,
              showCursor: false,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(buttonFocus),
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                focusNode: buttonFocus,
                onPressed: () {
                  if(textEditingController.text.isNotEmpty){
                    ApiServices.postMessages(
                        hotelId: hotelId,
                        roomNo: roomNo,
                        messages: textEditingController.text).then((value) =>
                        Navigator.pop(context)).then((value) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Message sent succesfully"),
                              behavior: SnackBarBehavior.floating,)));
                  }

                },
                child: const Text(
                  "Send",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      },
    ).then((_) {
      _isAlertOpen = false;
      notifyListeners();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      firstNode.requestFocus();
    });
  }

  //this alert box used to show mess timing
  void showMessTiming({required BuildContext context, required Size size}) {
    _isAlertOpen = true;
    notifyListeners();
    FocusNode firstNode = FocusNode();

    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          alignment: Alignment.center,
          scrollable: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          focusColor: const Color(0xff81d1ff).withOpacity(0.2),
                          focusNode: firstNode,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: size.width * 0.03,
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Mess Timing",
                        style: TextStyle(
                            fontFamily: 'DegularDemo',
                            color: Colors.white,
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: ApiServices.getMessDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white,
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty ||
                            snapshot.data == null) {
                          return Center(
                              child: Text(
                            "Not Available",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.055,
                                fontWeight: FontWeight.w600),
                          ));
                        } else {
                          var data = snapshot.data![0];

                          List<String> timings = [
                            '${data["breakfast"]}',
                            ' ${data["lunch"]}',
                            '${data["dinner"]}',
                          ];

                          return Center(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03),
                              itemCount: 3,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: size.width * 0.025,
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: size.width * 0.25,
                                      height: size.height * 0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(images[index])),
                                      ),
                                    ),
                                    Text(
                                      mess[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.width * 0.03,
                                        color: Colors.white,
                                        fontFamily: 'DegularDemo',
                                      ),
                                    ),
                                    Text(
                                      timings[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: size.width * 0.023,
                                        color: Colors.white,
                                        fontFamily: 'DegularDemo',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  )
                ],
              )),
        );
      },
    ).then((_) {
      isClicked = false;
      _isAlertOpen = false;
      notifyListeners();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      firstNode.requestFocus();
    });
  }

  final FocusNode firstFocusNode = FocusNode();

  void focusFirstNode() {
    if (!firstFocusNode.hasFocus) {
      firstFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    firstFocusNode.dispose();
    super.dispose();
  }
}

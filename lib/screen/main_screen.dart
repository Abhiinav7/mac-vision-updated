import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controller/main_controller.dart';
import '../controller/menu_controller.dart';
import '../controller/room_service_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _onKey(KeyEvent event) {
    final mainController = Provider.of<MainController>(context, listen: false);
    final roomServiceController = Provider.of<RoomServiceController>(context, listen: false);
    final menuController = Provider.of<MenuProvider>(context, listen: false);
    final key = event.logicalKey;

    //this function is to check whether the alert box is open  then the keyboard event should stop ,because in this app most pages contain alert box that used because it can easily controll the keyboard event
    bool isAnyAlertBoxOpen() {
      return roomServiceController.isAlertBoxOpen ||
          mainController.isAlertOpen ||
          menuController.isAlertOpen;
    }

    if (!isAnyAlertBoxOpen() && event is KeyDownEvent) {
      if (key == LogicalKeyboardKey.arrowRight) {
        mainController.changeSelectedPages(
          (mainController.selectedPages + 1) % mainController.pages.length,
        );
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        mainController.changeSelectedPages(
          (mainController.selectedPages - 1 + mainController.pages.length) %
              mainController.pages.length,
        );
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MainController>(
      builder: (context, mainController, child) {
        return Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/bg/bg.png"),
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: mainController.pages
                        .elementAt(mainController.selectedPages),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.height * 0.0222,
                    vertical: size.height * 0.0200,
                  ),
                  height: size.height * 0.13,
                  width: size.width,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double tabWidth =
                          constraints.maxWidth / mainController.tabs.length -
                              10;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mainController.tabs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              mainController.changeSelectedPages(index);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.height * 0.009),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.0222),
                                color: mainController.selectedPages == index
                                    ? const Color(0xff0029ff)
                                    : const Color(0xffffffff).withOpacity(0.2),
                              ),
                              width: tabWidth,
                              child: mainController.tabs[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

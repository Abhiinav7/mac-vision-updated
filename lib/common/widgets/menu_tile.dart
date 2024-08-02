import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile(
      {super.key,
      required this.size,
      required this.img,
      required this.title,
      required this.subTitle,
      this.focusNode,
      required this.onTap});

  final Size size;
  final String img;
  final String title;
  final String subTitle;
  final FocusNode? focusNode;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      focusColor: const Color(0xff81d1ff),
      focusNode: focusNode,
      child: Container(
          margin: const EdgeInsets.all(4),
          height: size.height * 0.17,
          width: size.width * 0.50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(9)),
          child: Row(
            children: [
              Container(
                width: size.width * 0.125,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: AssetImage(img)
                    )),

              ),
              SizedBox(
                width: size.width * 0.04,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.03,
                      fontFamily: 'DegularDemo',
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * 0.02,
                      fontFamily: 'DegularDemo',
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

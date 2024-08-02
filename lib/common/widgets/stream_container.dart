import 'package:flutter/material.dart';
class StreamContainer extends StatelessWidget {
  const StreamContainer({
    super.key,
    required this.focusNode,
    required this.img,
    required this.title,
    required this.onTap,
  });

  final FocusNode focusNode;
  final String img;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
        onTap: onTap,
        focusNode: focusNode,
        borderRadius: BorderRadius.circular(12),
        focusColor: const Color(0xff81d1ff),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            height: size.height * 0.46,
            width: size.width * 0.2,
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  img,
                  height: size.height * 0.22,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  title,
                  style:  TextStyle(
                      fontSize: size.width * 0.025,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ));
  }
}

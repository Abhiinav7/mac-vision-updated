import 'package:flutter/material.dart';
class BottomTab extends StatelessWidget {
  const BottomTab({super.key, required this.icon, required this.iconName});

 final String icon;
 final String iconName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Image.asset(icon,height: size.height * 0.056,fit: BoxFit.fitHeight,),
        Text(
          iconName,
          style: TextStyle(color: Colors.white, fontSize: size.height * 0.036,fontFamily: 'DegularDemo',fontWeight: FontWeight.w500),
        )
      ],
    );
    ;
  }
}

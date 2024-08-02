import"package:flutter/material.dart";
class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.focusNode,
  });

  final String title;
  final void Function()? onTap;
  final IconData? icon;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        left: size.height * 0.028,
        top: size.height * 0.028,
      ),
      child: ListTile(
        focusNode: focusNode,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.0223),
        ),
        tileColor: Colors.white,
        focusColor: const Color(0xff81d1ff),
        title: Text(
          title,
          style: TextStyle(
          fontFamily: 'DegularDemo',
              fontSize: size.height * 0.040,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
        leading: Icon(
          icon,
        ),
      ),
    );
  }
}

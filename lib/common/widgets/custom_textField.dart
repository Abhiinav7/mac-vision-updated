import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hintText,
      this.keyboardType = TextInputType.name,
      this.focusNode,
      this.onFieldSubmitted});

  final TextEditingController controller;
  final String label;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          label: Text(label),
          labelStyle:
              TextStyle(fontSize: size.height * 0.024, color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.024,
          ),
          errorStyle:
              TextStyle(color: Colors.white, fontSize: size.height * 0.024),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.0222),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.0222),
            borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.0222),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.0222),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          )),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Field is empty';
        }
        return null;
      },
    );
  }
}

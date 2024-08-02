import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/controller/auth_controller.dart';
import '../../common/widgets/custom_textField.dart';

class HotelRegister extends StatelessWidget {
  HotelRegister({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
        body: Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg/hotel_auth_bg.jpeg'),
              fit: BoxFit.cover)),
      child: Center(
        child: Container(
          width: size.height * 0.84,
          height: size.width * 0.31,
          padding: EdgeInsets.all(size.height * 0.028),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.9),
                blurRadius: 1,
                spreadRadius: 2,
              ),
            ],
            color: Colors.blue[800],
            borderRadius: BorderRadius.circular(size.height * 0.0222),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hotel Credentials',
                      style: TextStyle(
                        fontFamily: 'DegularDemo',
                        color: Colors.white,
                          fontSize: size.height * 0.048,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextField(
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(authController.roomFocusNode),
                      focusNode: authController.hotelIdFocusNode,
                      controller: authController.hotelIdController,
                      label: "Id",
                      hintText: "Enter Id"),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomTextField(
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(authController.buttonFocusNode),
                      focusNode: authController.roomFocusNode,
                      controller: authController.roomNoController,
                      label: "Room",
                      hintText: "Enter Room No"),
                  SizedBox(
                    height: size.height * 0.030,
                  ),
                  ElevatedButton(
                      focusNode: authController.buttonFocusNode,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          authController.saveHotelDetails();
                         authController.showRestartDialog(context, size);
                        }
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.indigo),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

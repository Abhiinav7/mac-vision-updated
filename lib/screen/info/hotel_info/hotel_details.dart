import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../controller/hotel_controller.dart';

class HotelDetailsDialog extends StatelessWidget {
  const HotelDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelController = Provider.of<HotelController>(context);
    Size size = MediaQuery.of(context).size;
    return Dialog(
      surfaceTintColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:  size.width * 0.04,vertical:size.height * 0.04 ),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: hotelController.isLoad
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "$getUrl${hotelController.hotelLogo}",
                      ),
                      radius: size.height * 0.080,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotelController.hotelName.toString().trim(),
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'DegularDemo',
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            maxLines: 1,
                            hotelController.hotelLocation.toString(),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'DegularDemo',
                              fontSize: size.width * 0.024,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  children: [
                    const Icon(Icons.mail_outline, color: Color(0xff001AFF)),
                    const SizedBox(width: 5),
                    Text(
                      hotelController.hotelEmail.toString().trim(),
                      style: TextStyle(
                        fontFamily: 'DegularDemo',
                        fontSize: size.width * 0.019,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Color(0xff001AFF)),
                    const SizedBox(width: 5),
                    Text(
                      hotelController.hotelPhone.toString().trim(),
                      style: TextStyle(
                        fontSize: size.width * 0.019,
                        fontFamily: 'DegularDemo',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

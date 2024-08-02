import 'package:flutter/material.dart';
class CompanyDetailsDialog extends StatelessWidget {
  const CompanyDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.04),
        child: SizedBox(
          width: size.width * 0.35,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/maclogo.png',
                      height: size.height * 0.10,
                    ),
                    Text(
                      'MACVISION',
                      style: TextStyle(
                        fontFamily: 'DegularDemo',
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff1075C0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.018),
                Center(
                  child: Text(
                    'Mahincha IT Solutions LLP',
                    style: TextStyle(
                      fontFamily: 'DegularDemo',
                      fontSize: size.width * 0.022,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'KSA  INDIA  SRILANKA',
                    style: TextStyle(
                      fontFamily: 'DegularDemo',
                      fontSize: size.width * 0.015,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    Text(
                      "Contact us",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'DegularDemo',
                        fontSize: size.width * 0.020,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.015),
                _buildContactRow(
                  context,
                  icon: Icons.email,
                  text: 'contact@mahincha.com',
                  size: size,
                ),
                SizedBox(height: size.height * 0.015),
                _buildContactRow(
                  context,
                  icon: Icons.phone,
                  text: '+91 9544666362',
                  size: size,
                ),
                SizedBox(height: size.height * 0.015),
                _buildContactRow(
                  context,
                  icon: Icons.phone,
                  text: '+966 553011362',
                  size: size,
                ),
                SizedBox(height: size.height * 0.03),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Our Products',
                    style: TextStyle(
                      fontFamily: 'DegularDemo',
                      decoration: TextDecoration.underline,
                      fontSize: size.width * 0.020,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                _buildContactRow(
                  context,
                  icon: Icons.connected_tv_rounded,
                  text: 'MacVision - Iptv Software',
                  size: size,
                ),
                SizedBox(height: size.height * 0.01),
                _buildContactRow(
                  context,
                  icon: Icons.shopping_cart,
                  text: 'Mahincha.com - E commerce',
                  size: size,
                ),
                SizedBox(height: size.height * 0.01),
                _buildContactRow(
                  context,
                  icon: Icons.local_taxi,
                  text: 'MahiGo - Taxi Service App',
                  size: size,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context,
      {required IconData icon, required String text, required Size size}) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigoAccent),
          SizedBox(width: size.width * 0.01),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'DegularDemo',
                fontSize: size.width * 0.016,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

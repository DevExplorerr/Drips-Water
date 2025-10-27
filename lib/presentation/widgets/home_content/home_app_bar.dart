import 'package:drips_water/presentation/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xff3FBDF1),
      height: 225,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    // style: GoogleFonts.poppins(
                    //   color: Colors.white,
                    //   fontSize: screenWidth * 0.03,
                    //   fontWeight: FontWeight.w600,
                    // ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04),
              child: Text(
                "Welcome!",
                // style: GoogleFonts.poppins(
                //   color: Colors.white,
                //   fontSize: screenWidth * 0.06,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              height: screenHeight * 0.07,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlue[500],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Search Something...",
                        // hintStyle: GoogleFonts.rubik(
                        //   color: Colors.white,
                        //   fontSize: screenWidth * 0.035,
                        //   fontWeight: FontWeight.w400,
                        // ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    iconSize: screenWidth * 0.06,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

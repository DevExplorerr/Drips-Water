import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const TopSection(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const CustomSlider(),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    "Water type",
                    // style: GoogleFonts.rubik(
                    //   color: const Color(0xff000000),
                    //   fontSize: screenWidth * 0.045,
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        waterTypeContainer(
                          const Color(0xff212121),
                          "All",
                          screenWidth,
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        waterTypeContainer(
                          const Color(0x99212121),
                          "Distilled",
                          screenWidth,
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        waterTypeContainer(
                          const Color(0x99212121),
                          "Spring",
                          screenWidth,
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        waterTypeContainer(
                          const Color(0x99212121),
                          "Purified",
                          screenWidth,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // const WaterGridPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget waterTypeContainer(Color color, String text, double screenWidth) {
    return Container(
      height: screenWidth * 0.1,
      width: screenWidth * 0.23,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(screenWidth * 0.025),
      child: Center(
        child: Text(
          text,
          // style: GoogleFonts.poppins(
          //   color: const Color(0xffFFFFFF),
          //   fontSize: screenWidth * 0.03,
          //   fontWeight: FontWeight.w400,
          // ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:learning_english/pages/home_page.dart';
import 'package:learning_english/values/app_assets.dart';
import 'package:learning_english/values/app_colors.dart';
import 'package:learning_english/values/app_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome To',
                    style: AppStyles.h3,
                  ),
                )),
            Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'English',
                        style: AppStyles.h2.copyWith(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          'Qoutes"',
                          textAlign: TextAlign.right,
                          style: AppStyles.h4.copyWith(height: 0.5),
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: AppColors.lightBlue,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                              (route) => false);
                    },
                    child: Image.asset(AppAssets.rightArrow),
                  ),
                ))
          ],
        ),
      ),
    );
  }

}

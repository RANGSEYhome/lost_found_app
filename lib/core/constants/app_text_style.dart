import 'package:flutter/material.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';

class AppTextSizes {
  static const double headline1 = 32;
  static const double headline2 = 24;
  static const double bodyTextLarge = 20;
  static const double bodyTextMedium = 18;
  static const double bodyTextSmall = 14;
  static const double caption = 12;
}

class AppTextFonts {
  static const String primaryFont = "KantumruyPro";
}

class AppTextStylesLight {
  static const TextStyle headline1 = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.headline1,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static const TextStyle headline2 = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.headline2,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static const TextStyle bodyTextLarge = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextLarge,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );
  static const TextStyle bodyTextMedium = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );
  static const TextStyle bodyTextSmall = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.caption,
    fontWeight: FontWeight.w300,
    color: AppColors.black,
  );
}

class AppTextStylesDark {
  static const TextStyle headline1 = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.headline1,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static const TextStyle headline2 = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.headline2,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  static const TextStyle bodyTextLarge = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextLarge,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );
  static const TextStyle bodyTextMedium = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );
  static const TextStyle bodyTextSmall = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.bodyTextSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: AppTextSizes.caption,
    fontWeight: FontWeight.w300,
    color: AppColors.white,
  );
}
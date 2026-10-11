import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';

import 'app_font_weight.dart';

class AppTextStyles {
  static const String fontFamily = 'Inter';

  // Headings
  static const heading36BlackBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.black,
    height: 1.2,
  );

  static const heading32BlackBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: AppFontWeight.bold,
    color: AppColors.black,
    height: 1.25,
  );

  static const heading28BlackBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: AppFontWeight.bold,
    color: AppColors.black,
    height: 1.3,
  );

  static const heading24BlackBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: AppFontWeight.bold,
    color: AppColors.black,
  );

  // Onboarding
  static const onboardingGreenBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.primaryGreen,
    height: 1.2,
  );

  static const onboardingDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textGrey,
    height: 1.5,
  );

  // Body Text
  static const body18GreyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const body16DarkRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textDark,
  );

  static const body16GreyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textGrey,
  );

  static const body14GreyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textGrey,
  );

  static const body14DarkRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textDark,
  );

  // Text Fields
  static const hint16GreyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
    color: AppColors.hintGrey,
  );

  static const input16DarkMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textDark,
  );

  // Buttons
  static const button18WhiteSemiBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.white,
  );

  static const button16WhiteSemiBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.white,
  );

  // Links
  static const link16GreenSemiBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.primaryGreen,
  );

  static const link14GreenMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: AppFontWeight.medium,
    color: AppColors.primaryGreen,
  );

  // Small Text
  static const caption12GreyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textGrey,
  );
}

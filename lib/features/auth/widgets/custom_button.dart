import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.buttonText,
    this.buttonTextColor,
    required this.press,
    this.size,
    this.flag,
  });
  final String? buttonText;
  final Color? buttonTextColor;
  final Function() press;
  final double? size;
  final bool? flag;

  final BoxDecoration boxDecor1 = BoxDecoration(
    border: Border.all(color: const Color(0xFF2E8B57), width: 2),
    borderRadius: BorderRadius.circular(14.r),
  );

  final BoxDecoration boxDecor2 = BoxDecoration(
    color: const Color(0xFF2E8B57),
    borderRadius: BorderRadius.circular(14.r),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: flag! ? boxDecor1 : boxDecor2,
        child: Center(
          child: Text(
            buttonText ?? " ",
            style: AppTextTheme.kLabelStyle.copyWith(
                color: flag! ? Color(0xFF2E8B57) : AppColors.kLight,
                fontSize: size ?? 16),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class ButtonPrimary extends _CustomButton {
  const ButtonPrimary({
    super.key,
    required super.onPressed,
    required super.title,
  }) : super(
          color: AppColor.primary,
          titleColor: Colors.white,
        );
}

class ButtonThird extends _CustomButton {
  const ButtonThird({
    super.key,
    required super.onPressed,
    required super.title,
  }) : super(
          color: Colors.white,
          titleColor: AppColor.primary,
        );
}

class ButtonSecondary extends _CustomButton {
  const ButtonSecondary({
    super.key,
    required super.onPressed,
    required super.title,
  }) : super(
          color: AppColor.secondary,
          titleColor: AppColor.primary,
        );
}

class ButtonDelete extends _CustomButton {
  const ButtonDelete({
    super.key,
    required super.onPressed,
    required super.title,
  }) : super(
          color: AppColor.error,
          titleColor: Colors.white,
        );
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.color,
    required this.titleColor,
  });

  final void Function()? onPressed;
  final String title;
  final Color color;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            double.infinity,
            54,
          ),
        ),
        overlayColor: const WidgetStatePropertyAll(
          AppColor.secondary,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(titleColor),
        backgroundColor: WidgetStatePropertyAll(color),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.suffixIcon,
      this.suffixOnTap,
      this.minLines,
      this.maxLines});

  final TextEditingController controller;
  final String hintText;
  final String? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final void Function()? suffixOnTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.textBody,
      ),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        fillColor: AppColor.colorWhite,
        filled: true,
        suffixIcon: suffixIcon == null
            ? null
            : GestureDetector(
                onTap: suffixOnTap,
                child: UnconstrainedBox(
                  alignment: const Alignment(0.3, 0),
                  child: ImageIcon(
                    AssetImage(suffixIcon!),
                    size: 24,
                    color: AppColor.primary,
                  ),
                ),
              ),
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.all(20),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: AppColor.textBody,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColor.primary, width: 2),
        ),
      ),
    );
  }
}

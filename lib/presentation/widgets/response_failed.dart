import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class ResponseFailed extends StatelessWidget {
  const ResponseFailed({
    super.key,
    this.margin = const EdgeInsets.all(0),
    required this.message,
  });
  final EdgeInsetsGeometry margin;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.colorWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
                color: AppColor.textBody,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: AppColor.textBody,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

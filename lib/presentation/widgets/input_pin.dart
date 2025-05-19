import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class InputPin extends StatefulWidget {
  const InputPin({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  final TextEditingController controller;
  final String hintText;
  final String icon;

  @override
  State<InputPin> createState() => _InputPinState();
}

class _InputPinState extends State<InputPin> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.primary,
        ),
        decoration: InputDecoration(
          fillColor: AppColor.primary.withOpacity(0.1),
          filled: true,
          prefixIcon: UnconstrainedBox(
            alignment: const Alignment(0.3, 0),
            child: ImageIcon(
              AssetImage(widget.icon),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColor.primary,
              size: 20,
            ),
            onPressed: _toggleVisibility,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: AppColor.textBody,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.color,
    this.textColor,
    this.width,
    this.fontSize,
    this.padding,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          padding: padding,
          backgroundColor: color ?? Theme.of(context).colorScheme.primary,
          overlayColor: color == null
              ? Colors.grey.shade50
              : Theme.of(context).colorScheme.primary, //
          // Custom
          // highlight color
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Helvetica Neue Roman',
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}

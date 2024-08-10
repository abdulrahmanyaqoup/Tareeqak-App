import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.padding,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
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
    );
  }
}

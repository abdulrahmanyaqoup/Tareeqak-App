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
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: !isLoading ? onPressed : null,
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
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style:
                    TextStyle(fontSize: 16, color: textColor ?? Colors.white),
              ),
      ),
    );
  }
}

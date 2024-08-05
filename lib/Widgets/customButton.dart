import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        minimumSize: Size(width ?? double.infinity, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 16,
        ),
      ),
    );
  }
}


class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white.withOpacity(0.8),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 30, color: Colors.white),
    );
  }
}
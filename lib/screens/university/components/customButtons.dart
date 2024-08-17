import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  const CustomButtons({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.2),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                blurRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            enableFeedback: true,
            highlightColor: Colors.transparent,
            icon: Icon(icon, color: iconColor, size: 50),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

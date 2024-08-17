import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.icon,
    required this.value,
    this.label,
    super.key,
  });

  final IconData icon;
  final String? label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 25,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label == null)
                const SizedBox()
              else
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              Text(
                value.isEmpty ? '-' : value,
                softWrap: false,
                style: TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

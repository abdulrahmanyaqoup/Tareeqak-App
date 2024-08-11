import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({
    required this.onSearchChanged,
    required this.hintText,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (pointerEvent) {
        FocusScope.of(context).unfocus();
      },
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade500.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

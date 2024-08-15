import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({
    required this.onSearchChanged,
    required this.hintText,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final String hintText;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onTapOutside: (pointerEvent) {
        FocusScope.of(context).unfocus();
      },
      onChanged: widget.onSearchChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  CupertinoIcons.clear_thick_circled,
                ),
                onPressed: () {
                  _controller.clear();
                  widget.onSearchChanged(
                    '',
                  );
                },
              )
            : const Icon(Icons.search),
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

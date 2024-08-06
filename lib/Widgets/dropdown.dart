import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final Function(String?) onChanged;
  final IconData prefixIcon;
  final bool? enabled;

  const Dropdown({
    super.key,
    this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.enabled,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    String? initialItem = widget.items.contains(widget.value) ? widget.value : null;

    return FormField<String>(
      initialValue: initialItem,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown.search(
              enabled: widget.enabled ?? true,
              initialItem: initialItem ,
              hintText: widget.hintText,
              validator: (value) {
                if (value == null) {
                  return 'Please select ${widget.hintText}';
                }
                return null;
              },
              items: widget.items,
              onChanged: widget.enabled ?? true
                  ? (value) {
                      state.didChange(value.toString());
                      widget.onChanged(value.toString());
                    }
                  : null,
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.grey.shade500.withOpacity(0.1),
                prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[700]),
                closedBorderRadius: BorderRadius.circular(8),
                expandedBorderRadius: BorderRadius.circular(8),
                closedBorder:
                    Border.all(color: Colors.grey.shade500.withOpacity(0.1)),
                expandedBorder:
                    Border.all(color: Colors.grey.shade500.withOpacity(0.1)),
                hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575)),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

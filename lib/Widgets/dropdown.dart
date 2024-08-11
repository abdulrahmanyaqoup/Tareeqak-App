import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.enabled,
  });

  final String? value;
  final String hintText;
  final List<String> items;
  final void Function(String?) onChanged;
  final IconData prefixIcon;
  final bool? enabled;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialItem =
        widget.items.contains(widget.value) ? widget.value : null;

    return PrimaryScrollController(
      controller: _scrollController,
      child: FormField<String>(
        initialValue: initialItem,
        builder: (FormFieldState<String> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                enabled: widget.enabled ?? true,
                disabledDecoration: CustomDropdownDisabledDecoration(
                  fillColor: Colors.grey.shade300,
                  headerStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[700]),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
                initialItem: initialItem,
                hintText: widget.hintText,
                validator: (value) {
                  if (value == null) {
                    return 'Please ${widget.hintText}';
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
                  listItemDecoration: ListItemDecoration(
                    splashColor: Colors.grey.shade200,
                  ),
                  listItemStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                  closedFillColor: Colors.grey.shade500.withOpacity(0.1),
                  prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[700]),
                  expandedFillColor: Colors.grey.shade50,
                  expandedShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 0.5,
                    ),
                  ],
                  searchFieldDecoration: SearchFieldDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey.shade500.withOpacity(0.1),
                  ),
                  expandedBorderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
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
      ),
    );
  }
}

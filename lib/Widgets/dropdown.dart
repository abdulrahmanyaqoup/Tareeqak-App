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
                closedHeaderPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                overlayHeight: 250,
                enabled: widget.enabled ?? true,
                itemsListPadding: const EdgeInsets.only(bottom: 10),
                disabledDecoration: CustomDropdownDisabledDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  fillColor: Colors.grey.shade300,
                  headerStyle: const TextStyle(
                    overflow: TextOverflow.fade,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[700]),
                  hintStyle: const TextStyle(
                    overflow: TextOverflow.fade,
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
                  closedBorderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  listItemDecoration: ListItemDecoration(
                    splashColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    highlightColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  listItemStyle: TextStyle(
                    overflow: TextOverflow.fade,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                  closedFillColor: Colors.grey.shade500.withOpacity(0.1),
                  prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[700]),
                  expandedFillColor: Colors.grey.shade50,
                  expandedSuffixIcon: Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.grey[700],
                  ),
                  expandedShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  expandedBorderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  headerStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.fade,
                  ),
                  hintStyle: const TextStyle(
                    overflow: TextOverflow.fade,
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

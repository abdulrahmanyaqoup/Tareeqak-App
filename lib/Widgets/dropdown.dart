import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final Function(String?) onChanged;
  final IconData prefixIcon;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<String>(
              enabled: enabled,
              items: items,
              selectedItem: value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  prefixIcon: Icon(prefixIcon),
                  hintText: hintText,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: state.hasError
                        ? const BorderSide(color: Colors.red, width: 1.0)
                        : BorderSide(color: Colors.grey.shade500.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: state.hasError
                        ? const BorderSide(color: Colors.red, width: 1.0)
                        : BorderSide(color: Colors.grey.shade500.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: state.hasError
                        ? const BorderSide(color: Colors.red, width: 1.0)
                        : BorderSide(color: Colors.grey.shade500.withOpacity(0.1)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade500.withOpacity(0.1),
                ),
              ),
              onChanged: (newValue) {
                state.didChange(newValue);
                onChanged(newValue);
              },
              popupProps: PopupProps.menu(
                menuProps:  MenuProps(
                  backgroundColor: Colors.white,
                  barrierColor: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search...',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                constraints: const BoxConstraints(maxHeight: 190, minHeight: 100),
                title: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    hintText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                fit: FlexFit.tight,
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
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

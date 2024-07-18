// search_university.dart
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchUniversity extends StatelessWidget {
  const SearchUniversity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15 , top: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SearchField(
          suggestions: [],
          suggestionState: Suggestion.expand,
          textInputAction: TextInputAction.next,
          hint: 'Search for a university',
          searchStyle: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.6),
          ),
          searchInputDecoration: InputDecoration(
            hintText: 'Search for a university',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

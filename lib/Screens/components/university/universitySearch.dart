// search_university.dart
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchUniversity extends StatelessWidget {
  const SearchUniversity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.centerLeft,
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
    );
  }
}

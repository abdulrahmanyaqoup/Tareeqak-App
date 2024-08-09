import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Models/University/major.dart';
import '../../../Models/University/school.dart';
import '../../../Models/User/user.dart';
import '../majorScreen.dart';
import '../schoolScreen.dart';

class GridModalBottomSheet extends StatefulWidget {
  const GridModalBottomSheet({
    required this.title,
    required this.items,
    super.key,
    this.noRoute,
    this.universityVolunteers,
    this.schoolVolunteers,
  });

  final String title;
  final List<dynamic> items;
  final bool? noRoute;
  final List<User>? universityVolunteers;
  final List<User>? schoolVolunteers;

  @override
  GridModalBottomSheetState createState() => GridModalBottomSheetState();
}

class GridModalBottomSheetState extends State<GridModalBottomSheet> {
  String searchQuery = '';
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = widget.items
          .where(
            (item) => ((item as dynamic).name as String)
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(filteredItems.length, (index) {
                  final item = filteredItems[index];
                  return InkWell(
                    onTap: () {
                      if (widget.noRoute != null && widget.noRoute!) {
                        Navigator.pop(context, (item as dynamic).name);
                      } else {
                        if (item is School) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => SchoolScreen(
                                universityVolunteers:
                                    widget.universityVolunteers ?? [],
                                school: item,
                              ),
                            ),
                          );
                        } else if (item is Major) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => MajorScreen(
                                schoolVolunteers: widget.schoolVolunteers ?? [],
                                major: item,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.school,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              (item as dynamic).name as String,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

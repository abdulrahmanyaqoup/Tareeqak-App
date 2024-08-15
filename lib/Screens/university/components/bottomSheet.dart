import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/models.dart';
import '../../../widgets/search.dart';
import '../majorScreen.dart';
import '../schoolScreen.dart';

class GridModalBottomSheet extends StatefulWidget {
  const GridModalBottomSheet({
    required this.title,
    required this.items,
    super.key,
    this.noRoute,
    this.universityAdvisors,
    this.schoolAdvisors,
    this.universityWebsite,
  });

  final String title;
  final List<dynamic> items;
  final bool? noRoute;
  final List<User>? universityAdvisors;
  final List<User>? schoolAdvisors;
  final String? universityWebsite;

  @override
  State<GridModalBottomSheet> createState() => _GridModalBottomSheet();
}

class _GridModalBottomSheet extends State<GridModalBottomSheet> {
  String _searchQuery = '';
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = widget.items
          .where(
            (item) => ((item as dynamic).name as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
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
          Search(
            hintText: 'Search...',
            onSearchChanged: updateSearchQuery,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(_filteredItems.length, (index) {
                  final item = _filteredItems[index];
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
                                universityAdvisors:
                                    widget.universityAdvisors ?? [],
                                school: item,
                                universityWebsite: widget.universityWebsite,
                              ),
                            ),
                          );
                        } else if (item is Major) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => MajorScreen(
                                schoolAdvisors: widget.schoolAdvisors ?? [],
                                major: item,
                                universityWebsite: widget.universityWebsite,
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
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

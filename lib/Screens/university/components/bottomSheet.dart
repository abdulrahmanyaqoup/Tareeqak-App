import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../majorScreen.dart';
import '../schoolScreen.dart';

class GridModalBottomSheet extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final bool? noRoute;
  final List<User>? universityVolunteers;
  final List<User>? schoolVolunteers;

  const GridModalBottomSheet({
    super.key,
    this.noRoute,
    this.universityVolunteers,
    this.schoolVolunteers,
    required this.title,
    required this.items,
  });

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
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () {
                      if (noRoute != null && noRoute!) {
                        Navigator.pop(context, item.name);
                      } else {
                        if (item is School) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SchoolScreen(
                                universityVolunteers: universityVolunteers ?? [],
                                school: item,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MajorScreen(
                                schoolVolunteers: schoolVolunteers ?? [],
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
                            spreadRadius: 2,
                            blurRadius: 5,
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
                              item.name,
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

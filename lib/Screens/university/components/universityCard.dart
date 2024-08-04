import 'package:finalproject/Models/University/university.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../universityScreen.dart';

class UniversityCard extends StatelessWidget {
  final University university;

  const UniversityCard({
    super.key,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: _buildContent(context),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UniversityScreen(university: university,),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 0,
            blurRadius: 3,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(university.name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center),
          Text('Amman', style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

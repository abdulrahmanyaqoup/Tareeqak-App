import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/models.dart';
import '../universityScreen.dart';

class UniversityCard extends StatelessWidget {
  const UniversityCard({
    required this.university,
    super.key,
  });

  final University university;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetail(context),
      child: _buildContent(context),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => UniversityScreen(
          university: university,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/universities/ju.png',
            height: 80,
            width: 80,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              university.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            university.city,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

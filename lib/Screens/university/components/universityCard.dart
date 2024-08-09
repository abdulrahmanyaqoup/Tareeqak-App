import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Models/University/university.dart';
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            'assets/images/universities/ju.svg',
            width: 80,
            height: 80,
          ),
          Text(
            university.name,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            university.city,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

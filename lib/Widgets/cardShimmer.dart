import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../Screens/advisors/components/customIconButton.dart';
import '../Widgets/infoRow.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({
    super.key,
    this.showButtons = true,
    this.isProfile = false,
  });

  final bool isProfile;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isProfile ? 3 : 0,
      shadowColor: Colors.white,
      color: isProfile ? Colors.white : Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Theme.of(context).colorScheme.primary,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'University of Jordan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const InfoRow(
                icon: CupertinoIcons.book,
                label: 'School',
                value: 'School of Engineering',
              ),
              const SizedBox(height: 10),
              const InfoRow(
                icon: CupertinoIcons.pen,
                label: 'Major',
                value: 'Computer Science',
              ),
              const SizedBox(height: 10),
              if (isProfile)
                const SizedBox()
              else
                Row(
                  children: [
                    CustomIconButton(
                      icon: FontAwesomeIcons.envelope,
                      color: Colors.green.withOpacity(0.8),
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    CustomIconButton(
                      icon: FontAwesomeIcons.whatsapp,
                      color: Colors.green.withOpacity(0.8),
                      onTap: () {},
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../model/models.dart';
import '../../advisors/components/advisorCard.dart';

class AdvisorsSheet extends StatelessWidget {
  const AdvisorsSheet({
    required this.title,
    super.key,
    this.advisors,
  });

  final String title;
  final List<User>? advisors;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (advisors!.isEmpty || advisors == null)
            Padding(
              padding:  EdgeInsets.only(top: size.height * 0.2),
              child: Text(
                'No advisors found!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: advisors?.length,
                itemBuilder: (context, index) {
                  final advisors = this.advisors?[index];
                  return AdvisorCard(user: advisors!);
                },
              ),
            ),
        ],
      ),
    );
  }
}

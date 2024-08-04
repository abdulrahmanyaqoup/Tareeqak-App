import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerCard.dart';
import 'package:flutter/material.dart';

class VolunteersSheet extends StatelessWidget {
  final String title;
  final List<User>? volunteers;

  const VolunteersSheet({
    super.key,
    required this.title,
    this.volunteers,
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
          if (volunteers!.isEmpty || volunteers == null)
            Text(
              'No volunteers available',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: volunteers?.length,
                itemBuilder: (context, index) {
                  final volunteer = volunteers?[index];
                  return VolunteerCard(user: volunteer!);
                },
              ),
            ),
        ],
      ),
    );
  }
}

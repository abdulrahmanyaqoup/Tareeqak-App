import 'package:flutter/material.dart';import '../../../model/User/user.dart';import '../../advisors/components/advisorCard.dart';class AdvisorsSheet extends StatelessWidget {  const AdvisorsSheet({    required this.title,    super.key,    this.advisors,  });  final String title;  final List<User>? advisors;  @override  Widget build(BuildContext context) {    return Container(      padding: const EdgeInsets.all(16),      decoration: BoxDecoration(        color: Theme.of(context).colorScheme.surface,        borderRadius: const BorderRadius.only(          topLeft: Radius.circular(15),          topRight: Radius.circular(15),        ),      ),      child: Column(        mainAxisSize: MainAxisSize.min,        children: [          Text(            title,            style: TextStyle(              color: Theme.of(context).colorScheme.primary,              fontSize: 20,              fontWeight: FontWeight.bold,            ),          ),          const SizedBox(height: 16),          if (advisors!.isEmpty || advisors == null)            Text(              'No advisors found',              style: TextStyle(                color: Theme.of(context).colorScheme.error,                fontSize: 16,                fontWeight: FontWeight.bold,              ),            )          else            Expanded(              child: ListView.builder(                itemCount: advisors?.length,                itemBuilder: (context, index) {                  final advisors = this.advisors?[index];                  return AdvisorCard(user: advisors!);                },              ),            ),        ],      ),    );  }}
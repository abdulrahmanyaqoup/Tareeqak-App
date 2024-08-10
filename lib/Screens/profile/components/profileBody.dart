import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../Widgets/customButton.dart';
import 'buttonShimmer.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    required this.height,
    super.key,
    this.buttonText,
    this.greeting,
    this.onPressed,
    this.isLoading = false,
  });

  final String? buttonText;
  final String? greeting;
  final bool isLoading;
  final double height;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.25),
      height: height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Lottie.asset(
                'assets/animations/logo.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const ProfileLoadingBody()
            else
              ProfileDataBody(
                greeting: greeting,
                buttonText: buttonText,
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileLoadingBody extends StatelessWidget {
  const ProfileLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ButtonShimmer(height: 30),
        SizedBox(height: 10),
        ButtonShimmer(height: 60),
      ],
    );
  }
}

class ProfileDataBody extends StatelessWidget {
  const ProfileDataBody({
    required this.greeting,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final String? greeting;
  final String? buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          greeting!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          onPressed: onPressed!,
          text: buttonText!,
        ),
      ],
    );
  }
}

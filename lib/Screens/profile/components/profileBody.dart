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
      margin: EdgeInsets.only(top: height * 0.16),
      height: height * 0.75,
      width: 500,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: height * 0.15),
            Lottie.asset(
              height: 200,
              'assets/animations/logo.json',
              fit: BoxFit.cover,
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
        ButtonShimmer(height: 40, width: 250),
        ButtonShimmer(
          height: 40,
          width: 250,
        ),
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
          width: 180,
          onPressed: onPressed!,
          text: buttonText!,
        ),
      ],
    );
  }
}

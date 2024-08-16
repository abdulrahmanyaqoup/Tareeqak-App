import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../app.dart';
import 'profileScreen.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({required this.isProfile, super.key});

  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Welcome to Tareeqak',
          body: 'Tareeqak helps high school graduates make informed decisions '
              'about their future academic paths.',
          image: Center(
            child: Image.asset('assets/images/tareeqak_logo.png', height: 300),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Explore Opportunities',
          body:
              'Uncover diverse universities and specialized majors that align '
              'with your ambitions.',
          image: Center(
            child: Image.asset(
              'assets/images/manual/universities.png',
              height: 300,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Get Personalized Assistance',
          body: 'Our Aspire AI and real advisors are here to help you with any '
              'questions you might have.',
          image: Center(
            child: Image.asset('assets/images/manual/AI.png', height: 300),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Connect with Peer Advisors',
          body: 'Connect with university students for firsthand advice.',
          image: Center(
            child:
                Image.asset('assets/images/manual/advisors.png', height: 200),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Your Data is Secure',
          body: 'We prioritize your privacy. Your personal information is safe '
              'and secure with us.',
          image: Center(
            child: Icon(
              Icons.security,
              size: 200,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          decoration: getPageDecoration(),
        ),
      ],
      onDone: () => goToProfile(context),
      onSkip: () => goToProfile(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: getDotsDecorator(),
    );
  }

  void goToProfile(BuildContext context) {
    !isProfile
        ? Navigator.of(context).pushReplacement(
            CupertinoPageRoute<ProfileScreen>(
              builder: (_) => const App(),
            ),
          )
        : Navigator.of(context).pop();
  }

  DotsDecorator getDotsDecorator() => DotsDecorator(
        size: const Size.square(10),
        activeSize: const Size(22, 10),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      );

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 15),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.only(top: 50),
      );
}

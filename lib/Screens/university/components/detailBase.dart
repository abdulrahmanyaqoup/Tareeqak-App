import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Widgets/infoRow.dart';
import '../../../env/env.dart';

class DetailBase extends StatelessWidget {
  DetailBase({
    required this.title,
    required this.description,
    required this.facts,
    required this.buttons,
    super.key,
    this.logo,
    this.city,
    this.universityType,
  });

  final String title;
  final String? logo;
  final String description;
  final String? city;
  final String? universityType;
  final List<String> facts;
  final List<Widget> buttons;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        border: null,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8, top: 8),
                                  child: Text(
                                    title,
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (city == null)
                                  const SizedBox()
                                else
                                  InfoRow(
                                    icon: Icons.location_on,
                                    value: city!,
                                  ),
                                const SizedBox(height: 8),
                                if (universityType == null)
                                  Container()
                                else
                                  InfoRow(
                                    icon: Icons.school,
                                    value: universityType!,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (logo != null && logo!.isNotEmpty)
                            Image(
                              image: CachedNetworkImageProvider(
                                '${Env.URI}$logo',
                                headers: {'apikey': Env.API_KEY},
                              ),
                              width: 110,
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: PageView.builder(
                                  itemCount: facts.length,
                                  controller: _pageController,
                                  itemBuilder: (context, index) => Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        facts[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: facts.length,
                              effect: WormEffect(
                                dotWidth: 12,
                                dotHeight: 12,
                                activeDotColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buttons,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

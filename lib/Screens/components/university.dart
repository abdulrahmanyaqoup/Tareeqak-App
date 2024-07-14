import 'package:flutter/material.dart';

class UniversityPage extends StatefulWidget {
  const UniversityPage({super.key});

  @override
  State<UniversityPage> createState() => _UniversityHomePageState();
}

class _UniversityHomePageState extends State<UniversityPage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Example seed color
      body: Stack(
        children: [
          Positioned(
            top: 70, // Adjust as needed
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),
          Positioned(
            top: screenHeight * 0.2, // Adjust according to your design needs
            left: 0,
            right: 0,
            bottom: 0, // Leaving space at the bottom
            child: _buildGridContainer(screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      title: const Text(
        'Welcome to University Hub!',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      subtitle: const Text(
        'Explore Universities',
        style: TextStyle(color: Colors.white54, fontSize: 18),
      ),
    );
  }

  Widget _buildGridContainer(double screenHeight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(38)),
      ),
      child: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const BouncingScrollPhysics(), 
      crossAxisCount: 2,
      crossAxisSpacing: 40,
      mainAxisSpacing: 30,
      children: List.generate(
        8,
        (index) => universityDashboard('University ${index + 1}',
            'assets/images/university_${index + 1}.png'),
      ),
    );
  }

  Widget universityDashboard(String title, String imagePath) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(imagePath, height: 40), 
            ),
            const SizedBox(height: 8),
            Text(title,
                style:
                    Theme.of(context).textTheme.titleMedium), 
          ],
        ),
      ),
    );
  }
}

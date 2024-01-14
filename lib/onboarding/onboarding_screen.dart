import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/constants_ui.dart';
import '../view/login_screen.dart';
import 'onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingWidget> pages = [
    const OnboardingWidget(
      title: 'Embark on Your Health Journey',
      description:
      'Get ready for a seamless experience with MedAlert.Your personal guide to medicine expiration alerts.',
      imagePath: ImageConstants.onboardImage1,
    ),
    const OnboardingWidget(
      title: 'Simplify Your Well-being',
      description:
      'Say goodbye to manual tracking.\n MedAlert effortlessly manages your medicines,\nso you can focus on living your best life.',
      imagePath: ImageConstants.onboardImage2,
    ),
    const OnboardingWidget(
      title: 'Stay Ahead with MedAlert',
      description:
      'No more surprises!\n MedAlert keeps you informed with timely notifications,putting your health in your hands.',
      imagePath: ImageConstants.onboardImage3,
    ),
  ];

  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentPage > 0)
                      AnimatedOpacityButton(
                        text: 'Previous',
                        onTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    if (currentPage == 0)
                      const SizedBox(width: 100.0), // Adjust the width as needed
                    if (currentPage > 0)
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: pages.length,
                        effect: const WormEffect(
                          // dotColor: Colors.red,
                          activeDotColor: Colors.red,
                        ),
                        // Choose the indicator effect
                      ),
                    if (currentPage < pages.length - 1)
                      AnimatedGradientButton(
                        text: 'Next',
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    if (currentPage == pages.length - 1)
                      AnimatedGradientButton(
                        text: 'Done',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedGradientButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.red,Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AnimatedOpacityButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedOpacityButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
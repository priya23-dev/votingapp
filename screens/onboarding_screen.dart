import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/slide1.png",
      "title": "Welcome to Votely",
      "description": "The online voting application. Create your account and stay tuned."
    },
    {
      "image": "assets/slide2.png",
      "title": "Stay Tuned",
      "description": "Follow each candidate's election campaign."
    },
    {
      "image": "assets/slide3.png",
      "title": "Make Your Choice",
      "description": "Vote for your favorite candidate and view results in real-time."
    },
  ];

  void _onNextPressed() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to LoginScreen using named route
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[index]['image']!, height: 300),
                    const SizedBox(height: 40),
                    Text(
                      onboardingData[index]['title']!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onboardingData[index]['description']!,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text("Skip", style: TextStyle(color: Colors.deepPurple)),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width: _currentIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Colors.deepPurple : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    _currentIndex == onboardingData.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

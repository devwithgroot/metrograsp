import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HeroCarousel extends StatefulWidget {
  @override
  _HeroCarouselState createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int _currentIndex = 0;

  // List of image paths (replace with your actual image paths)
  final List<String> slideImages = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
    'assets/carousel4.png',
  ];

  // Titles and subtitles for each slide
  final List<Map<String, String>> slideContent = [
    {
      'title': 'Track Your Cycle with Ease',
      'subtitle':
          'Stay informed about your menstrual health with intuitive cycle tracking and personalized insights.',
    },
    {
      'title': 'Predict Your Periods Accurately',
      'subtitle':
          'Get precise predictions for your next period, ovulation, and fertile window with our advanced algorithm.',
    },
    {
      'title': 'Empower Your Health Journey',
      'subtitle':
          'Understand your body better with daily health tips, mood tracking, and symptom analysis.',
    },
    {
      'title': 'Personalized Reminders & Alerts',
      'subtitle':
          'Never miss a beat with timely reminders for your period, ovulation, and self-care routines.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Adjust as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200], // Default container background
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: slideImages.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      slideImages[index],
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Title and Subtitle
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slideContent[index]['title']!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            slideContent[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1.0, // Full-width slides
              autoPlayInterval: Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          // Custom Dot Indicators
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slideImages.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 25 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

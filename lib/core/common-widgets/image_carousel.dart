import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const ImageCarousel({super.key, required this.imagePaths});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselSliderController,
          options: CarouselOptions(
              height: 200.0, // Height of the carousel
              autoPlay: true, // Enable auto-scrolling
              enlargeCenterPage: false, // Enlarge the center item
              aspectRatio: 16 / 9,
              autoPlayInterval: Duration(seconds: 3), // Time for each slide
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
          items: widget.imagePaths.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imagePaths.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselSliderController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? const Color(0xFF6FD73E) // Selected color
                      : const Color(0xFF999999), // Unselected color
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Widget build(BuildContext context) {
//     return CarouselSlider(
//       carouselController: _carouselController,
//       options: CarouselOptions(
//         height: 200.0, // Height of the carousel
//         autoPlay: true, // Enable auto-scrolling
//         enlargeCenterPage: true, // Enlarge the center item
//         aspectRatio: 16 / 9,
//         autoPlayInterval: Duration(seconds: 3), // Time for each slide
//         viewportFraction: 0.8,
//       ),
//       items: imagePaths.map((path) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.symmetric(horizontal: 5.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 image: DecorationImage(
//                   image: AssetImage(path),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

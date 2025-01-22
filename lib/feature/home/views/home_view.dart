import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:todo/core/common-widgets/image_carousel.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';
import 'package:todo/feature/home/views/widgets/header_widget.dart';
import 'package:todo/feature/home/views/widgets/recent_items_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.allContents(
        authViewModel.user?.id ?? 0,
        authViewModel.user?.companyId ?? "",
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'lib/core/resources/images/seed_logo.png',
      'lib/core/resources/images/code-wallpaper-preview.jpg',
      'lib/core/resources/images/code-coder-codes-coding.jpg',
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home Page"),
      // ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(
              height: 11,
            ),
            ImageCarousel(imagePaths: imagePaths),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 510.0,
              child: ListViewData(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50.0), right: Radius.circular(50.0)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF6FD73E),
          unselectedItemColor: Color(0xFF999999),
          backgroundColor: Color(0xFFE3E3E3),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Course'),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        ),
      ),
    );
  }
}

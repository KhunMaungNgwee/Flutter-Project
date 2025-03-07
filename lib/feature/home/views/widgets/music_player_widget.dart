import 'package:flutter/material.dart';
import 'package:todo/feature/home/views/widgets/audio_progress_bar.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0)),
              child: Container(
                height: 110,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF1C4C95), // Dark green
                    Color.fromARGB(255, 29, 100, 28),
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
              top: 50,
              left: 25,
              right: 25,
              height: 850,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: AudioPlyerScreen(),
              )
              // Container(
              //     height: 300,
              //     decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.circular(16.0),
              //     ),
              //     child: Expanded(
              //         child: Column(
              //       children: [
              //         AudioPlyerScreen()

              //   )),
              ),
        ],
      ),
    );
  }
}

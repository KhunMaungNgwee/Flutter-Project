import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:todo/feature/home/models/content_response.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class AudioPlyerScreen extends StatefulWidget {
  const AudioPlyerScreen({super.key});

  @override
  State<AudioPlyerScreen> createState() => _AudioPlyerScreenState();
}

class _AudioPlyerScreenState extends State<AudioPlyerScreen> {
  late AudioPlayer _audioPlayer;

  // final _playlist = ConcatenatingAudioSource(
  //   children: [
  //     AudioSource.uri(
  //       Uri.parse(
  //           'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
  //       tag: MediaItem(
  //         id: '1',
  //         title: 'SoundHelix Song 2',
  //         artist: 'Super Shy',
  //         artUri: Uri.parse(
  //             'https://images.pexels.com/photos/7983350/pexels-photo-7983350.jpeg'),
  //       ),
  //     ),
  //     AudioSource.uri(
  //       Uri.parse('https://archive.org/download/test_audio/test_audio.mp3'),
  //       tag: MediaItem(
  //         id: '2',
  //         title: 'Test Audio',
  //         artist: 'Test Artist',
  //         artUri: Uri.parse('https://images.app.goo.gl/LbRNrMTnBXztcp688'),
  //       ),
  //     ),
  //   ],
  // );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    try {
      // Fetch audio data from backend
      // await homeViewModel.allContents(); // Ensure this method exists in your HomeViewModel
      // final audioItems = homeViewModel.contentFile; // Replace with your actual list of audio items

      // // Convert audio data to AudioSource playlist
      // Helper function: Declare this before it's used
      String sanitizeUrl(String contentFile) {
        // Keep only the URL part by splitting at newline and trimming
        return contentFile.split('\n').last.trim();
      }

      // final ContentModel item =
      //     GoRouterState.of(context).extra! as ContentModel;
      final List<AudioSource> audioSources =
          homeViewModel.contents!.map((item) {
        try {
          // Sanitize URLs
          final contentFile =
              sanitizeUrl(item.contentFile); // Use the helper function
          final optimizeLink = item.optimizeLink.trim();

          // Validate URLs
          // if (!Uri.tryParse(contentFile)!.hasScheme ?? true) {
          //   throw FormatException('Invalid contentFile URL: $contentFile');
          // }
          // if (!Uri.tryParse(optimizeLink)!.hasScheme ?? true) {
          //   throw FormatException('Invalid optimizeLink URL: $optimizeLink');
          // }

          return AudioSource.uri(
            Uri.parse(contentFile),
            tag: MediaItem(
              id: item.id.toString(),
              title: item.contentName,
              artist: 'Super Shy',
              artUri: Uri.parse(optimizeLink),
            ),
          );
        } catch (e) {
          print('Error initializing audio source for item ${item.id}: $e');
          throw e;
        }
      }).toList();

      final playlist = ConcatenatingAudioSource(children: audioSources);

      // Set the audio source
      await _audioPlayer.setLoopMode(LoopMode.all);
      await _audioPlayer.setAudioSource(playlist);

      debugPrint('Audio source loaded successfully from backend');
    } catch (e) {
      debugPrint('Error initializing audio source: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Stack(
      children: [
        StreamBuilder<SequenceState?>(
          stream: _audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            final sequenceState = snapshot.data;
            final currentMediaItem =
                sequenceState?.currentSource?.tag as MediaItem?;
            final imageUrl = currentMediaItem?.artUri?.toString() ??
                'https://source.unsplash.com/random'; // Fallback image

            return CachedNetworkImage(
              imageUrl: imageUrl,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        ),

        // Frosted Glass Effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur intensity
          child: Container(
            color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   // colors: [Color(0xFF144771), Color(0xFF071A2C)]
          // )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go("/home");
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 10, top: 20),
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 80, 107, 155),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 30,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Sound",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 80),
              StreamBuilder(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshop) {
                  final state = snapshop.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return MediaMetadata(
                      title: metadata.title,
                      imageUrl: metadata.artUri.toString(),
                      artist: metadata.artist ?? '');
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.black12,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              Controls(audioPlayer: _audioPlayer)
            ],
          ),
        ),
      ],
    );
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    this.title,
    this.artist,
  });
  final String imageUrl;
  final String? title;
  final String? artist;
  @override
  Widget build(BuildContext context) {
    print(imageUrl);

    return Column(
      children: [
        Text(
          artist!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl, // Make sure imageUrl is defined or passed
              height: 300,
              width: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 60,
          color: Colors.white,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(); // Loading indicator while state is null
            }

            final playerState = snapshot.data!;
            final processingState = playerState.processingState;
            final playing = playerState.playing;

            debugPrint('Player state: $playerState'); // Debug log

            if (!playing) {
              return IconButton(
                onPressed: () async {
                  try {
                    await audioPlayer.play();
                  } catch (e) {
                    debugPrint('Error on play button: $e');
                  }
                },
                icon: const Icon(Icons.play_arrow_rounded),
                color: Colors.white,
                iconSize: 80,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                icon: const Icon(Icons.pause_rounded),
                color: Colors.white,
                iconSize: 80,
              );
            }

            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToNext,
          icon: const Icon(Icons.skip_next_rounded),
          color: Colors.white,
          iconSize: 60,
        )
      ],
    );
  }
}

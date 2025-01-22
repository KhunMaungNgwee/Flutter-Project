import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';

class ListViewData extends StatefulWidget {
  const ListViewData({super.key});

  @override
  State<ListViewData> createState() => _ListViewState();
}

class _ListViewState extends State<ListViewData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededed),
      body: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          if (homeViewModel.contents == null) {
            return const Center(child: Text('No data available.'));
          }

          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            itemCount: homeViewModel.contents?.length,
            itemBuilder: (context, index) {
              final item = homeViewModel.contents![index];
              final String fileExtension =
                  item.wordDescription.split('.').last.toLowerCase();

              // Determine icon based on file extension
              IconData iconStyle = Icons.book; // Default icon
              if (fileExtension == 'mp3') {
                iconStyle = Icons.volume_up;
              } else if (fileExtension == 'mp4') {
                iconStyle = Icons.video_camera_back_outlined;
              }

              return Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.pictureBackground.toString(),
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                size: 90, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between image and text
                    // Text and Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.wordDescription.toString(),
                            style: const TextStyle(
                              color: Color(0xFF48ed39),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.content_Name.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Youtube and Tiktok',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                              Icon(
                                iconStyle,
                                size: 20,
                                color: Colors.lightGreen,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const LinearProgressIndicator(
                            value: 0.3,
                            backgroundColor: Colors.grey,
                            color: Color(0xFF48ed39),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'End Date: 21 Sept 2024',
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

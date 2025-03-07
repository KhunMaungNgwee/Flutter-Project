import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/models/user_response.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';
import 'package:todo/feature/home/views/widgets/profile_widget.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String? _profilePic; // Store fetched profile pic URL
  String? _updatedPic; // Store updated profile pic URL

  @override
  void initState() {
    super.initState();
    _fetchProfilePic();
  }

  void _fetchProfilePic() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final profilePicUrl = await homeViewModel.getUserProfilePic(
        authViewModel.user?.id ?? 1129, context);

    if (mounted) {
      setState(() {
        _profilePic = profilePicUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C4C95), Color(0xFF4FB14E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 51.0, 18.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fusion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      authViewModel.user?.fullName.toString() ?? 'Khun',
                      style: const TextStyle(
                        color: Color(0xFFEFEFEF),
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF00B9FF),
                      size: 15.0,
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Enjoy your work today.',
                  style: TextStyle(
                    color: Color(0xFFEFEFEF),
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard("Course", "20"),
                    const SizedBox(width: 14.0),
                    _buildInfoCard("Events", "11"),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 20.0, 24.0, 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    final updatedUserData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileWidget(
                                userData: authViewModel.user,
                                profilePic: _profilePic,
                              )),
                    );

                    if (updatedUserData is ProfileResponse) {
                      setState(() {
                        _updatedPic = updatedUserData.profilePic?.fileName;
                        authViewModel.updateUserName(
                          updatedUserData.prefix,
                          updatedUserData.firstName,
                          updatedUserData.lastName,
                          updatedUserData.gender,
                          updatedUserData.email,
                        );
                      });
                    }
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      image: _updatedPic != null
                          ? DecorationImage(
                              image: NetworkImage(_updatedPic!),
                              fit: BoxFit.cover,
                            )
                          : _profilePic != null
                              ? DecorationImage(
                                  image:
                                      MemoryImage(base64Decode(_profilePic!)),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: NetworkImage(
                                    'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1455&webp=1',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 8.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 78,
      height: 53,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14.0),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

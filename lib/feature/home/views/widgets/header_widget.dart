import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

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
      )),
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
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      authViewModel.user?.fullName.toString() ?? 'Khun',
                      style: TextStyle(
                        color: Color(0xFFEFEFEF),
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: 14.0,
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF00B9FF),
                      size: 15.0,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
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
                    Container(
                      width: 78,
                      height: 53,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Course',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '20',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .grey, // Optional: Different color for the second text
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Container(
                      width: 78,
                      height: 53,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Events',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '11',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .grey, // Optional: Different color for the second text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 20.0, 24.0, 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              authViewModel.user?.profilePic.toString() ?? ''),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 8.0,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

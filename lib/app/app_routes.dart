import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/common-widgets/main_layout.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/auth/views/login_screen.dart';
import 'package:todo/feature/home/views/home_view.dart';
import 'package:todo/feature/error/error_page.dart';
import 'package:todo/feature/home/views/widgets/audio_progress_bar.dart';
import 'package:todo/feature/home/views/widgets/music_player_widget.dart';
import 'package:todo/feature/home/views/widgets/profile_widget.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String home = '/home';
  static const String error = '/error';
  static const String music = '/music';
  static const String audio = "/audio";
  static const String profile = "/profile";

  // Create GoRouter instance
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: login,
      redirect: (context, state) {
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        final isAuthenticated = authViewModel.isAuthenticated;
        final isLoggingIn = state.location == login;

        // Redirect to login if not authenticated and not already on login
        if (!isAuthenticated && state.location != login) {
          return login;
        }

        // Redirect to home if authenticated and trying to access login
        if (isAuthenticated && isLoggingIn) {
          return home;
        }

        // No redirection needed
        return null;
      },
      routes: [
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: music,
          builder: (context, state) => const MusicPlayerWidget(),
        ),
        GoRoute(
          path: profile,
          builder: (context, state) => const ProfileWidget(),
        ),
        ShellRoute(
            builder: (context, state, child) {
              return MainLayout(child: child);
            },
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const Home(),
              ),
              GoRoute(
                path: audio,
                builder: (context, state) => const AudioPlyerScreen(),
              ),
              GoRoute(
                path: error,
                builder: (context, state) => const ErrorPage(),
              ),
            ]),
      ],
      errorBuilder: (context, state) => const ErrorPage(),
    );
  }
}

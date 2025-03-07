import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app/app_providers.dart';
import 'package:todo/core/resources/styles/theme.dart';
import 'package:todo/core/resources/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/app/app_routes.dart';
import 'package:camera/camera.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraDescription firstCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Builder(
        builder: (context) {
          final router = AppRoutes.createRouter(context);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('th', ''),
            ],
            locale: const Locale('en', ''),
          );
        },
      ),
    );
  }
}

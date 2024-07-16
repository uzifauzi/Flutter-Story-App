import 'package:final_subs_story_app/provider/maps_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/api/api_service.dart';
import 'data/repository/auth_repository.dart';
import 'provider/api_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/picture_provider.dart';
import 'provider/story_provider.dart';
import 'routes/router_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    authProvider = AuthProvider(authRepository: authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ApiProvider(ApiService(AuthRepository())),
        ),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(
            create: (_) => StoryProvider(
                apiService: ApiService(AuthRepository()),
                authRepository: AuthRepository())),
        ChangeNotifierProvider(create: (_) => PictureProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                MapsProvider(initLat: -6.8957473, initLon: 107.6337669))
      ],
      child: Consumer<AuthProvider>(
        builder: (context, value, child) {
          return MaterialApp.router(
            title: 'Story App',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', ''),
              Locale('en', ''),
            ],
            theme: ThemeData(
              useMaterial3: true,
            ),
            routerConfig: routerConfig(context),
          );
        },
      ),
    );
  }
}

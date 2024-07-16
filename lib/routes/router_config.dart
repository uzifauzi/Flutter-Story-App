import 'package:final_subs_story_app/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../screens/detail_story_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/picker_location.dart';
import '../screens/register_screen.dart';
import '../screens/upload_screen.dart';
import '../utils/flavor_config.dart';

GoRouter routerConfig(BuildContext context) {
  AuthProvider authProvider = Provider.of(context, listen: false);
  return GoRouter(
      initialLocation: authProvider.token.isNotEmpty ? '/' : '/login',
      routes: [
        GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
            routes: [
              GoRoute(
                path: 'register',
                name: 'register',
                builder: (context, state) => const RegisterScreen(),
              ),
            ]),
        GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: 'detail',
                builder: (context, state) {
                  String storyId = state.pathParameters['id'] ?? '';
                  return DetailStoryScreen(storyId: storyId);
                },
              ),
              GoRoute(
                path: 'upload',
                name: 'upload',
                builder: (context, state) {
                  return const UploadScreen();
                },
              ),
              if (FlavorConfig.instance.flavor == FlavorType.paid)
                GoRoute(
                  path: 'picker/:lat/:lon',
                  name: 'picker',
                  builder: (context, state) {
                    return PickerLocationScreen(
                      lat: double.parse(state.pathParameters['lat']!),
                      lon: double.parse(state.pathParameters['lon']!),
                    );
                  },
                ),
              GoRoute(
                path: 'maps',
                name: 'maps',
                builder: (context, state) {
                  // Convert String to bool
                  return const MapsScreen();
                },
              ),
            ]),
      ]);
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/story_provider.dart';
import '../utils/enum.dart';
import '../widgets/story_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final storyProvider = context.read<StoryProvider>();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //       scrollController.position.maxScrollExtent) {
    //     if (storyProvider.pageItems != null) {
    //       storyProvider.fetchAllStories();
    //     }
    //   }
    // });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyProvider.pageItems != null &&
            storyProvider.state != ResultState.loading) {
          storyProvider.fetchAllStories();
        }
      }
    });

    Future.microtask(() async => storyProvider.fetchAllStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xfff5f6fa),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.goNamed('upload');
            },
            child: const Icon(Icons.camera),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.titleApp,
                      style: GoogleFonts.parisienne()
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    Row(
                      children: [
                        Consumer<StoryProvider>(
                          builder: (ctx, story, _) {
                            return IconButton(
                                onPressed: () async {
                                  await story.refreshPage();
                                  if (ctx.mounted) ctx.goNamed('maps');
                                },
                                icon: const Icon(Icons.map));
                          },
                        ),
                        Consumer<AuthProvider>(
                          builder: (ctx, auth, _) {
                            return IconButton(
                              onPressed: () async {
                                auth.removeLoginToken();
                                ctx.go('/login');
                              },
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Consumer<StoryProvider>(
                    builder: (context, story, _) {
                      final allStories = story.allStories ?? [];
                      if (story.state == ResultState.error) {
                        return Text(story.message ?? 'Coba lagi nanti');
                      } else if (story.state == ResultState.success) {
                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: allStories.length +
                              (story.pageItems != null ? 1 : 0),
                          itemBuilder: (ctx, index) {
                            if (index == allStories.length &&
                                story.pageItems != null) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return GestureDetector(
                                onTap: () async {
                                  story.fetchStoryById(allStories[index].id);
                                  context.goNamed('detail', pathParameters: {
                                    'id': allStories[index].id
                                  });
                                },
                                child: StoryItem(story: allStories[index]));
                          },
                        );
                      } else {
                        return LoadingAnimationWidget.fallingDot(
                            color: Colors.white, size: 50);
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}

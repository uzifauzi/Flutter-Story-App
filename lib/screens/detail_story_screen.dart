import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/story_provider.dart';
import '../utils/enum.dart';
import '../widgets/detail_story_content.dart';

class DetailStoryScreen extends StatelessWidget {
  const DetailStoryScreen({required this.storyId, super.key});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Story',
            style: GoogleFonts.quicksand()
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.success) {
            return DetailStoryContent(story: state.story!);
          } else {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
